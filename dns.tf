resource "aws_route53_zone" "karbonak_link" {
    name = "karbonak.link"
    lifecycle {
      prevent_destroy = true
    }
}

resource "aws_route53domains_registered_domain" "karbonak_link" {
  domain_name = "karbonak.link"
}

resource "aws_route53_zone" "jacot-descombes_net"  {
  name = "jacot-descombes.net"
    lifecycle {
      prevent_destroy = true
    }
}

resource "aws_route53domains_registered_domain" "jacot-descombes_net" {
  domain_name = "jacot-descombes.net"
}

resource "aws_route53_zone" "fleurdelys-deux_ch" {
    name = "fleurdelys-deux.ch"
    lifecycle {
      prevent_destroy = true
    }
}


resource "aws_route53_record" "karbonak_link_MX" {
  zone_id = aws_route53_zone.karbonak_link.zone_id
  name = "karbonak.link."
  type = "MX"
  ttl = 300
  records = [
    "0 karbonak-link.mail.protection.outlook.com.",
  ]
  allow_overwrite = true
}

resource "aws_route53_record" "karbonak_link_TXT" {
  zone_id = aws_route53_zone.karbonak_link.zone_id
  name = "karbonak.link."
  type = "TXT"
  ttl = 300
  records = [
    "MS=ms10941321",
    "v=spf1 include:spf.protection.outlook.com -all",
  ]
  allow_overwrite = true
}

resource "aws_route53_record" "karbonak_link_autodiscover_CNAME" {
  zone_id = aws_route53_zone.karbonak_link.zone_id
  name = "autodiscover.karbonak.link."
  type = "CNAME"
  ttl = 300
  records = [
    "autodiscover.outlook.com.",
  ]
  allow_overwrite = true
}

resource "aws_route53_record" "fleurdelys_deux_ch_A" {
  zone_id = aws_route53_zone.fleurdelys-deux_ch.zone_id
  name = "fleurdelys-deux.ch."
  type = "A"
  ttl = 300
  records = [
    "54.77.83.193",
  ]
  allow_overwrite = true
}

resource "aws_route53_record" "fleurdelys_deux_ch_MX" {
  zone_id = aws_route53_zone.fleurdelys-deux_ch.zone_id
  name = "fleurdelys-deux.ch."
  type = "MX"
  ttl = 300
  records = [
    "10 mx.thirty.org",
  ]
  allow_overwrite = true
}

resource "aws_route53_record" "fleurdelys_deux_ch_TXT" {
  zone_id = aws_route53_zone.fleurdelys-deux_ch.zone_id
  name = "fleurdelys-deux.ch."
  type = "TXT"
  ttl = 300
  records = [
    "MS=ms18571339",
  ]
  allow_overwrite = true
}

