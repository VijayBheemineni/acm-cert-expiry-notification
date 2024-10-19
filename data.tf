data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/scripts"
  output_path = "${path.module}/python_output/lambda_function.zip"
}
