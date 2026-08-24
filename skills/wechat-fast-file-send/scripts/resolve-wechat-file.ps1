param(
    [Parameter(Mandatory = $true)]
    [string]$Query,

    [Parameter(Mandatory = $true)]
    [string]$SearchRoot,

    [switch]$Recurse,

    [ValidateRange(1, 50)]
    [int]$MaxResults = 10
)

$ErrorActionPreference = 'Stop'

$root = (Resolve-Path -LiteralPath $SearchRoot).Path
if (-not (Test-Path -LiteralPath $root -PathType Container)) {
    throw "Search root was not found or is not a directory: $SearchRoot"
}

function Normalize-FileText([string]$Value) {
    $normalized = $Value.Normalize([Text.NormalizationForm]::FormKC).ToLowerInvariant()
    return [regex]::Replace($normalized, '[\s\p{P}\p{S}_-]+', '')
}

function Get-LongestCommonSubstringLength([string]$Left, [string]$Right) {
    if ([string]::IsNullOrEmpty($Left) -or [string]::IsNullOrEmpty($Right)) { return 0 }
    $previous = New-Object 'int[]' ($Right.Length + 1)
    $best = 0
    for ($i = 1; $i -le $Left.Length; $i++) {
        $current = New-Object 'int[]' ($Right.Length + 1)
        for ($j = 1; $j -le $Right.Length; $j++) {
            if ($Left[$i - 1] -eq $Right[$j - 1]) {
                $current[$j] = $previous[$j - 1] + 1
                if ($current[$j] -gt $best) { $best = $current[$j] }
            }
        }
        $previous = $current
    }
    return $best
}

$normalizedQuery = Normalize-FileText $Query
if ([string]::IsNullOrWhiteSpace($normalizedQuery)) { throw 'Query must contain letters or numbers' }

$imageExtensions = @('.png', '.jpg', '.jpeg', '.webp', '.bmp', '.gif')
$fileSearch = if ($Recurse) {
    Get-ChildItem -LiteralPath $root -Recurse -File -ErrorAction SilentlyContinue
} else {
    Get-ChildItem -LiteralPath $root -File -ErrorAction SilentlyContinue
}
$candidates = $fileSearch |
    Where-Object { $imageExtensions -contains $_.Extension.ToLowerInvariant() } |
    ForEach-Object {
        $name = [IO.Path]::GetFileNameWithoutExtension($_.Name)
        $normalizedName = Normalize-FileText $name
        $isExact = $normalizedName -eq $normalizedQuery
        $isSubstring = $normalizedName.Contains($normalizedQuery) -or $normalizedQuery.Contains($normalizedName)
        $lcs = Get-LongestCommonSubstringLength $normalizedQuery $normalizedName
        $denominator = [Math]::Max($normalizedQuery.Length, $normalizedName.Length)
        $substringScore = if ($denominator -gt 0) { $lcs / $denominator } else { 0 }
        $uniqueQueryCharacters = @($normalizedQuery.ToCharArray() | Select-Object -Unique)
        $sharedCharacters = @($uniqueQueryCharacters | Where-Object { $normalizedName.Contains($_) }).Count
        $overlapScore = $sharedCharacters / $uniqueQueryCharacters.Count
        $score = if ($isExact) { 1.0 } elseif ($isSubstring) { 0.9 } else { [Math]::Round((0.65 * $substringScore) + (0.35 * $overlapScore), 4) }
        [pscustomobject]@{
            FilePath = $_.FullName
            FileName = $_.Name
            Bytes = $_.Length
            Score = $score
            IsExactMatch = $isExact
            IsSubstringMatch = $isSubstring
        }
    } |
    Sort-Object -Property @{Expression = 'Score'; Descending = $true}, @{Expression = 'FileName'; Descending = $false} |
    Select-Object -First $MaxResults

if (-not $candidates) {
    [pscustomobject]@{ Query = $Query; SearchRoot = $root; Recommendation = 'NO_IMAGE_CANDIDATE'; Candidates = @() } |
        ConvertTo-Json -Depth 4 -Compress
    return
}

$best = @($candidates)[0]
$second = @($candidates)[1]
$scoreMargin = if ($second) { [Math]::Round($best.Score - $second.Score, 4) } else { $best.Score }
$autoSendEligible = $best.IsExactMatch -or ($best.IsSubstringMatch -and $scoreMargin -ge 0.2)
$recommendation = if ($autoSendEligible) { 'AUTO_SEND_ELIGIBLE' } else { 'REVIEW_REQUIRED' }

[pscustomobject]@{
    Query = $Query
    SearchRoot = $root
    Recommendation = $recommendation
    ScoreMargin = $scoreMargin
    Candidates = @($candidates)
} | ConvertTo-Json -Depth 5 -Compress

