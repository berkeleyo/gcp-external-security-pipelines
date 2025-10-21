<#
.SYNOPSIS
    Creates a GCP service account and (optionally) a key — demonstration only.
    Prefer Workload Identity Federation. Do not commit keys.
#>

param(
    [string]$ProjectId = "<your-project-id>",
    [string]$SaId = "sa-sec-bridge",
    [switch]$CreateKey
)

Write-Host "Setting project $ProjectId"
gcloud config set project $ProjectId | Out-Null

Write-Host "Creating service account $SaId"
gcloud iam service-accounts create $SaId --display-name "Security Bridge SA"

Write-Host "Granting Pub/Sub roles (if using bridge)"
gcloud projects add-iam-policy-binding $ProjectId `
  --member "serviceAccount:$SaId@$ProjectId.iam.gserviceaccount.com" `
  --role "roles/pubsub.subscriber"

if ($CreateKey) {
    Write-Warning "Keys are sensitive. Prefer WIF. This is for demonstration only."
    gcloud iam service-accounts keys create ".\${SaId}.json" `
      --iam-account "$SaId@$ProjectId.iam.gserviceaccount.com"
    Write-Host "Key written to .\${SaId}.json (do not commit)"
}
