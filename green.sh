#!/bin/bash
# GitHub 贡献图心形 + 随机绿地（不需要Python）

git checkout -b decor  # 新建分支，避免污染主分支

# 心形图案（从今天往前推）
for i in {1..30}; do
    for j in {1..7}; do
        # 简单心形逻辑（你可以随意改数字画其他图案）
        if (( (i%5==0 && j%3==1) || (i==10 && j==4) || (i==15 && j%2==0) )); then
            date_str=$(date -d "-$((i*7 + j)) days" +%Y-%m-%dT12:00:00)
            GIT_AUTHOR_DATE="$date_str" GIT_COMMITTER_DATE="$date_str" git commit --allow-empty -m "✨ decor" >/dev/null
            echo "绿了一格: $date_str"
        fi
    done
done

# 再加点随机绿地，看起来更自然
for ((k=0; k<100; k++)); do
    rand_days=$((RANDOM % 365 + 30))  # 最近一年内随机
    date_str=$(date -d "-$rand_days days" +%Y-%m-%dT12:00:00)
    GIT_AUTHOR_DATE="$date_str" GIT_COMMITTER_DATE="$date_str" git commit --allow-empty -m "📝 update notes" >/dev/null
done

git push origin decor --force
echo "完成！去GitHub看你的绿地，心形+随机点超自然！"