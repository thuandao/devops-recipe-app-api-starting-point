resource "aws_secretsmanager_secret" "db" {
  name = "${local.prefix}-db-credentials"
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    django_secret_key = var.django_secret_key
    db_host = aws_db_instance.main.address
    db_name = aws_db_instance.main.db_name
    username = aws_db_instance.main.username
    password = aws_db_instance.main.password
  })
}
