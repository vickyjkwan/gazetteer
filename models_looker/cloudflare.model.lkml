connection: "snowflake_production"

include: "aws_cloudflare*[!.][!.z].view.lkml"

fiscal_month_offset: -11

explore: cloudflare_logs {
  from: aws_cloudflare_logs
}

explore: aws_cloudflare_logs_top_ips {
  label: "Cloudflare Logs - Top 50 IPs"
}
