output "queue_arn" {
  description = "ARN of the Karpenter interruption queue."
  value       = aws_sqs_queue.this.arn
}

output "queue_name" {
  description = "Name to pass to Karpenter's interruption queue setting."
  value       = aws_sqs_queue.this.name
}
