locals {
  queue_name = "${var.resource_name_prefix}-karpenter-interruption"
  common_tags = merge(var.tags, {
    "managed-by" = "terraform"
  })

  event_rules = {
    scheduled_change = {
      source      = ["aws.health"]
      detail_type = ["AWS Health Event"]
    }
    spot_interruption = {
      source      = ["aws.ec2"]
      detail_type = ["EC2 Spot Instance Interruption Warning"]
    }
    rebalance_recommendation = {
      source      = ["aws.ec2"]
      detail_type = ["EC2 Instance Rebalance Recommendation"]
    }
    instance_state_change = {
      source      = ["aws.ec2"]
      detail_type = ["EC2 Instance State-change Notification"]
    }
    capacity_reservation_interruption = {
      source      = ["aws.ec2"]
      detail_type = ["EC2 Capacity Reservation Instance Interruption Warning"]
    }
  }
}

resource "aws_sqs_queue" "this" {
  name                              = local.queue_name
  message_retention_seconds         = var.message_retention_seconds
  sqs_managed_sse_enabled           = true
  receive_wait_time_seconds         = 20
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  tags                              = local.common_tags
}

resource "aws_sqs_queue_policy" "this" {
  queue_url = aws_sqs_queue.this.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "KarpenterInterruptionQueuePolicy"
    Statement = [
      {
        Sid    = "AllowEventBridgeSendMessage"
        Effect = "Allow"
        Principal = {
          Service = ["events.amazonaws.com", "sqs.amazonaws.com"]
        }
        Action   = "sqs:SendMessage"
        Resource = aws_sqs_queue.this.arn
      },
      {
        Sid       = "DenyInsecureTransport"
        Effect    = "Deny"
        Principal = "*"
        Action    = "sqs:*"
        Resource  = aws_sqs_queue.this.arn
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
    ]
  })
}

resource "aws_cloudwatch_event_rule" "this" {
  for_each = local.event_rules

  name = "${var.resource_name_prefix}-karpenter-${replace(each.key, "_", "-")}"
  event_pattern = jsonencode({
    source        = each.value.source
    "detail-type" = each.value.detail_type
  })
  tags = local.common_tags
}

resource "aws_cloudwatch_event_target" "this" {
  for_each = local.event_rules

  rule      = aws_cloudwatch_event_rule.this[each.key].name
  target_id = "KarpenterInterruptionQueue"
  arn       = aws_sqs_queue.this.arn

  depends_on = [aws_sqs_queue_policy.this]
}
