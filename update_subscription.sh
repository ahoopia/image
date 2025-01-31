#!/bin/bash

# 1. 使用 curl 获取订阅内容
SUBSCRIPTION_URL="https://vip.365cloud.me/api/v1/client/subscribe?token=3e4c357717b14920206609a28ceb389f"

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
    reject: { type: http, behavior: domain, url: 'https://alist.365ip.net/d/clash-rules/reject.txt?sign=tPqDS1sQ8pX2ro02KKTMKkxxzcNACT3llc9EgdORfRE=:0', path: ./ruleset/reject.yaml, interval: 86400 }
    icloud: { type: http, behavior: domain, url: 'https://alist.365ip.net/d/clash-rules/icloud.txt?sign=aR6hxsIVu2qn765nav3J3ltWKrGAA45SiQWN7cTjvtM=:0', path: ./ruleset/icloud.yaml, interval: 86400 }
    apple: { type: http, behavior: domain, url: 'https://alist.365ip.net/d/clash-rules/apple.txt?sign=-RS5BOYeEMfgkUA_OTExA0PepsUF8C_hbsaruWZYnsw=:0', path: ./ruleset/apple.yaml, interval: 86400 }
    google: { type: http, behavior: domain, url: 'https://alist.365ip.net/d/clash-rules/google.txt?sign=zhZ-t21SFJYTWEtM0la5v8cVRuVLXN-JNcGNg_ygRLU=:0', path: ./ruleset/google.yaml, interval: 86400 }
    proxy: { type: http, behavior: domain, url: 'https://alist.365ip.net/d/clash-rules/proxy.txt?sign=ZYFsIWaa9Qp44cGuPvv0kZZhq5QX6UsKj_I4vQwqRFo=:0', path: ./ruleset/proxy.yaml, interval: 86400 }
    direct: { type: http, behavior: domain, url: 'https://alist.365ip.net/d/clash-rules/direct.txt?sign=xoRLjmTpBDJ1YP-CKt5x2XCPIsSKEss4QW6HRQToWuI=:0', path: ./ruleset/direct.yaml, interval: 86400 }
    private: { type: http, behavior: domain, url: 'https://alist.365ip.net/d/clash-rules/private.txt?sign=Nt_aIZWDAoW6G7wjXdl0Do-fvMJ6U87VeuRlJ511v5o=:0', path: ./ruleset/private.yaml, interval: 86400 }
    gfw: { type: http, behavior: domain, url: 'https://alist.365ip.net/d/clash-rules/gfw.txt?sign=nwKfNQw6tUXfVNDG8y1nokzBWIQka2W-KhbQUF0RooI=:0', path: ./ruleset/gfw.yaml, interval: 86400 }
    tld-not-cn: { type: http, behavior: domain, url: 'https://alist.365ip.net/d/clash-rules/tld-not-cn.txt?sign=pcIqgqqnqhu_N6vHjjM91aHniGSBKc_rcAp0sqaqV_I=:0', path: ./ruleset/tld-not-cn.yaml, interval: 86400 }
    telegramcidr: { type: http, behavior: ipcidr, url: 'https://alist.365ip.net/d/clash-rules/telegramcidr.txt?sign=mil6mlysw9Mw_CHBsMK7Et5g_xjNshhddNDE5TMeP08=:0', path: ./ruleset/telegramcidr.yaml, interval: 86400 }
    cncidr: { type: http, behavior: ipcidr, url: 'https://alist.365ip.net/d/clash-rules/cncidr.txt?sign=S5AZ7lnTepgmdLWJg-Ru5eshMSsTHhqz3DSURjRIVkc=:0', path: ./ruleset/cncidr.yaml, interval: 86400 }
    lancidr: { type: http, behavior: ipcidr, url: 'https://alist.365ip.net/d/clash-rules/lancidr.txt?sign=5c0dcZR8uwUKPIVFaaP0R7YDbyhe0L45vxQfruAyF28=:0', path: ./ruleset/lancidr.yaml, interval: 86400 }
    applications: { type: http, behavior: classical, url: 'https://alist.365ip.net/d/clash-rules/applications.txt?sign=aJ1yNoIioJeheBgxMPFLvUg8WdIuhKANS-YLjG_DgAc=:0', path: ./ruleset/applications.yaml, interval: 86400 }
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
