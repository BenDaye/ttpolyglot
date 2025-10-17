#!/bin/bash

# 批量修复服务文件中的日志和异常调用

SERVICES_DIR="/Users/mac888/Desktop/www/ttpolyglot/packages/server/lib/src/services"

echo "开始批量修复服务文件..."

# 遍历所有服务目录
for dir in "business" "feature" "infrastructure"; do
    echo "处理 $dir 目录..."
    
    # 查找所有 dart 文件
    find "$SERVICES_DIR/$dir" -name "*.dart" -type f | while read -r file; do
        echo "  处理文件: $(basename "$file")"
        
        # 1. 删除 _logger 声明
        sed -i '' '/static final _logger = LoggerFactory.getLogger/d' "$file"
        
        # 2. 替换日志调用
        sed -i '' "s/_logger\.info('\([^']*\)'\([^)]*\));/logInfo('\1'\2);/g" "$file"
        sed -i '' 's/_logger\.info("\([^"]*\)"\([^)]*\));/logInfo("\1"\2);/g' "$file"
        
        sed -i '' "s/_logger\.warn('\([^']*\)'\([^)]*\));/logWarn('\1'\2);/g" "$file"
        sed -i '' 's/_logger\.warn("\([^"]*\)"\([^)]*\));/logWarn("\1"\2);/g' "$file"
        
        sed -i '' "s/_logger\.error('\([^']*\)'\([^)]*\));/logError('\1'\2);/g" "$file"
        sed -i '' 's/_logger\.error("\([^"]*\)"\([^)]*\));/logError("\1"\2);/g' "$file"
        
        sed -i '' "s/_logger\.debug('\([^']*\)'\([^)]*\));/logDebug('\1'\2);/g" "$file"
        sed -i '' 's/_logger\.debug("\([^"]*\)"\([^)]*\));/logDebug("\1"\2);/g' "$file"
        
        # 3. 替换 LoggerFactory.getLogger 调用
        sed -i '' 's/final logger = LoggerFactory\.getLogger/\/\/ final logger = LoggerFactory.getLogger/g' "$file"
        sed -i '' 's/final _logger = LoggerFactory\.getLogger/\/\/ final _logger = LoggerFactory.getLogger/g' "$file"
        
        # 4. 替换异常类型
        sed -i '' "s/throw const BusinessException(code: \([^,]*\), message: '\([^']*\)');/throwBusiness('\2');/g" "$file"
        sed -i '' 's/throw const BusinessException(code: \([^,]*\), message: "\([^"]*\)");/throwBusiness("\2");/g' "$file"
        
        sed -i '' "s/throw const BusinessException(message: '\([^']*\)');/throwBusiness('\1');/g" "$file"
        sed -i '' 's/throw const BusinessException(message: "\([^"]*\)");/throwBusiness("\1");/g' "$file"
        
        sed -i '' "s/throw const NotFoundException(message: '\([^']*\)');/throwNotFound('\1');/g" "$file"
        sed -i '' 's/throw const NotFoundException(message: "\([^"]*\)");/throwNotFound("\1");/g' "$file"
        
        sed -i '' "s/throw const ValidationException(message: '\([^']*\)');/throwValidation('\1');/g" "$file"
        sed -i '' 's/throw const ValidationException(message: "\([^"]*\)");/throwValidation("\1");/g' "$file"
    done
done

echo "修复完成！"

