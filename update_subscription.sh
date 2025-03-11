#!/bin/bash

# 1. 使用 curl 获取订阅内容
SUBSCRIPTION_URL="https://svip.365cloud.me/api/v1/client/subscribe?token=3e4c357717b14920206609a28ceb389f"

# 2. 下载订阅内容并保存为临时文件
TEMP_FILE=$(mktemp)
curl -s -A "Clash" "$SUBSCRIPTION_URL" > "$TEMP_FILE"

# 3. 删除 rules 字段
yq -Yi 'del(.rules)' "$TEMP_FILE"

# 4. 定义 rule-providers 和 rules（可修改）
RULE_PROVIDERS_FILE=$(mktemp)
RULES_FILE=$(mktemp)

cat > "$RULE_PROVIDERS_FILE" <<EOF
rule-providers:
  reject:
    type: http
    behavior: domain
    url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/reject.txt"
    path: ./ruleset/reject.yaml
    interval: 86400

  icloud:
    type: http
    behavior: domain
    url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/icloud.txt"
    path: ./ruleset/icloud.yaml
    interval: 86400

  apple:
    type: http
    behavior: domain
    url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/apple.txt"
    path: ./ruleset/apple.yaml
    interval: 86400

  google:
    type: http
    behavior: domain
    url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/google.txt"
    path: ./ruleset/google.yaml
    interval: 86400

  proxy:
    type: http
    behavior: domain
    url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/proxy.txt"
    path: ./ruleset/proxy.yaml
    interval: 86400

  direct:
    type: http
    behavior: domain
    url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/direct.txt"
    path: ./ruleset/direct.yaml
    interval: 86400

  private:
    type: http
    behavior: domain
    url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/private.txt"
    path: ./ruleset/private.yaml
    interval: 86400

  gfw:
    type: http
    behavior: domain
    url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/gfw.txt"
    path: ./ruleset/gfw.yaml
    interval: 86400

  tld-not-cn:
    type: http
    behavior: domain
    url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/tld-not-cn.txt"
    path: ./ruleset/tld-not-cn.yaml
    interval: 86400

  telegramcidr:
    type: http
    behavior: ipcidr
    url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/telegramcidr.txt"
    path: ./ruleset/telegramcidr.yaml
    interval: 86400

  cncidr:
    type: http
    behavior: ipcidr
    url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/cncidr.txt"
    path: ./ruleset/cncidr.yaml
    interval: 86400

  lancidr:
    type: http
    behavior: ipcidr
    url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/lancidr.txt"
    path: ./ruleset/lancidr.yaml
    interval: 86400

  applications:
    type: http
    behavior: classical
    url: "https://cdn.jsdelivr.net/gh/Loyalsoldier/clash-rules@release/applications.txt"
    path: ./ruleset/applications.yaml
    interval: 86400
EOF

cat > "$RULES_FILE" <<EOF
rules:
    - 'DOMAIN-SUFFIX,mushroomtrack.com,DIRECT'
    - 'DOMAIN-SUFFIX,sixyik.com,DIRECT'
    - 'DOMAIN-SUFFIX,surrit.com,DIRECT'
    - 'DOMAIN,main.365cloud.me,DIRECT'
    - 'RULE-SET,applications,🛰️ 全球直连'
    - 'DOMAIN,clash.razord.top,🛰️ 全球直连'
    - 'DOMAIN,yacd.haishan.me,🛰️ 全球直连'
    - 'RULE-SET,private,🛰️ 全球直连'
    - 'RULE-SET,reject,REJECT'
    - 'RULE-SET,icloud,🛰️ 全球直连'
    - 'RULE-SET,apple,🛰️ 全球直连'
    - 'RULE-SET,google,🌈 365Cloud'
    - 'RULE-SET,proxy,🌈 365Cloud'
    - 'RULE-SET,direct,🛰️ 全球直连'
    - 'RULE-SET,lancidr,🛰️ 全球直连'
    - 'RULE-SET,cncidr,🛰️ 全球直连'
    - 'RULE-SET,telegramcidr,🌈 365Cloud'
    - 'GEOIP,LAN,🛰️ 全球直连'
    - 'GEOIP,CN,🛰️ 全球直连'
    - 'MATCH,🌈 365Cloud'
EOF

# 5. 追加 rule-providers 和 rules
yq -Y '.' "$TEMP_FILE" "$RULE_PROVIDERS_FILE" "$RULES_FILE" > "$TEMP_FILE.tmp" && mv "$TEMP_FILE.tmp" "$TEMP_FILE"

# 6. 输出最终 YAML 文件
sed -i '/^---$/d' "$TEMP_FILE"
OUTPUT_FILE="modified_subscription.yaml"
mv "$TEMP_FILE" "$OUTPUT_FILE"

echo "YAML 文件已生成：$OUTPUT_FILE"

# 清理临时文件
rm -f "$RULE_PROVIDERS_FILE" "$RULES_FILE"
