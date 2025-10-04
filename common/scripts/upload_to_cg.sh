#!/bin/bash

# 递归上传指定目录及所有子目录下的所有文件

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --path)
            TARGET_DIR="$2"
            shift 2
            ;;
        --token)
            TOKEN="$2"
            shift 2
            ;;
        -h|--help)
            echo "用法: $0 --token=<临时Token> --path=<目录路径>"
            echo ""
            echo "参数:"
            echo "  --token     上传所需的临时Token (必需)"
            echo "  --path      要上传的目录路径 (必需)"
            echo "  -h, --help  显示帮助信息"
            echo ""
            echo "示例:"
            echo "  $0 --token=\"your-token\" --path=\"/path/to/models\""
            echo "  $0 --token=\"your-token\" --path=\".\""
            exit 0
            ;;
        *)
            echo "错误: 未知参数 '$1'"
            echo "使用 --help 查看帮助信息"
            exit 1
            ;;
    esac
done

# 检查必需参数
if [ -z "$TOKEN" ] || [ -z "$TARGET_DIR" ]; then
    echo "错误: 缺少必需参数 --token 或 --path"
    echo "使用 --help 查看帮助信息"
    exit 1
fi

# 检查目录是否存在
if [ ! -d "$TARGET_DIR" ]; then
    echo "错误: 目录 '$TARGET_DIR' 不存在"
    exit 1
fi

# 获取绝对路径
TARGET_DIR=$(realpath "$TARGET_DIR")

echo "开始上传目录: $TARGET_DIR"
echo "使用文件名作为模型名称"
echo "---"

# 查找所有文件并上传
find "$TARGET_DIR" -type f | while read -r file; do
    # 获取文件名作为模型名称
    MODEL_NAME=$(basename "$file")
    echo "正在上传: $file"
    echo "模型名称: $MODEL_NAME"

    cgtool upload model --token="$TOKEN" --name="$MODEL_NAME" "$file"

    # 检查上传是否成功
    if [ $? -eq 0 ]; then
        echo "✓ 上传成功: $file"
    else
        echo "✗ 上传失败: $file"
    fi
    echo "---"
done

echo "所有文件上传完成！"
