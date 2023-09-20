terraform {
    backend "s3" {
        bucket = "terraform-tfstate-speicher-fuer-pipeline-chrisli4000" # Dies gibt den Namen des S3-Buckets an, in dem der Terraform-Zustand gespeichert wird.
        key = "build/terraform.tfstate" #Dies ist der Pfad innerhalb des S3-Buckets, unter dem der Zustand gespeichert wird.
        region = "eu-central-1" # Dies gibt die AWS-Region an, in der sich der S3-Bucket befindet.
        profile = "build_benutzer" # Dies ist das AWS-Profil, das verwendet wird, um auf den S3-Bucket zuzugreifen.
    }
}

# Insgesamt ermöglicht dieser Code Terraform, seinen Zustand in einem S3-Bucket 
# in AWS zu speichern und zu verwalten. Dies ist besonders nützlich für 
# Teamarbeit und CI/CD-Pipelines, da es ermöglicht, den Terraform-Zustand 
# zwischen verschiedenen Maschinen zu teilen. Es ist auch eine gute Praxis 
# für die Verwaltung des Terraform-Zustands, da es hilft, Probleme mit 
# dem lokalen Zustand zu vermeiden.

## Der S3-Bucket, der als Backend für die `terraform.tfstate`-Datei 
## dient, wird nicht durch Terraform erstellt, sondern manuell über 
## die AWS-Webkonsole. Würde dieser Bucket durch Terraform erstellt, 
## könnte er durch den Befehl `terraform destroy` gelöscht werden, 
## was das Backup zerstören würde. Daher ist die manuelle Erstellung 
## notwendig.