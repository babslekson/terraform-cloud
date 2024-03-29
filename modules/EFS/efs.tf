# create elastic file system
resource "aws_efs_file_system" "efs" {
  creation_token = "efs"
  encrypted      = true
  kms_key_id     = var.kms_arn  

  tags = {
    Name = "efs"
  }
}
# set first mount target for the EFS 
resource "aws_efs_mount_target" "efs-mtg-1" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.efs-subnet-1
  security_groups = var.efs-sg
}
# set second mount target for the EFS 
resource "aws_efs_mount_target" "efs-mtg-2" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = var.efs-subnet-2
  security_groups = var.efs-sg
}


# create access point for tooling
resource "aws_efs_access_point" "tooling" {
  file_system_id = aws_efs_file_system.efs.id
  root_directory {
                    path = "/tooling"
                    creation_info {

                        owner_gid  = 0 
                        owner_uid  = 0
                        permissions = 0775
                    }
                 }
  posix_user {
                gid = 0
                uid = 0
  }

}
# create access point for wordpress
resource "aws_efs_access_point" "wordpress" {
  file_system_id = aws_efs_file_system.efs.id
  root_directory {
                    path = "/wordpress"
                    creation_info {

                        owner_gid  = 0 
                        owner_uid  = 0
                        permissions = 0775
                    }
                 }
  posix_user {
                gid = 0
                uid = 0
  }

}