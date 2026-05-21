# 图书电商系统

## 项目介绍

这是一个基于Spring Boot的图书电子商务系统，提供完整的在线购物功能，包括用户注册登录、商品浏览搜索、购物车管理、订单处理和支付功能等。系统还包含完善的后台管理功能，方便管理员进行商品、订单、用户和库存的管理。

## 技术栈

### 后端技术

- **框架**: Spring Boot 3.0.5 + Spring MVC
- **ORM框架**: MyBatis 3.0.0
- **数据库**: MySQL
- **缓存**: Caffeine
- **安全**: Spring Security、自定义安全过滤器
- **事务管理**: Spring声明式事务
- **分页**: PageHelper
- **连接池**: Druid

### 前端技术

- **视图层**: JSP + JSTL
- **JavaScript**: 原生JavaScript
- **CSS**: 原生CSS

### 其他技术

- **支付集成**: 支付宝SDK
- **邮件服务**: Spring Mail
- **构建工具**: Maven
- **代码生成**: Lombok
- **文档**: SpringDoc OpenAPI

## 功能特性

### 用户模块

- ✅ 用户注册、邮箱验证和激活
- ✅ 用户登录、登出
- ✅ 个人信息管理（修改资料、密码、头像）
- ✅ 忘记密码功能

### 商品模块

- ✅ 图书分类展示
- ✅ 图书列表和详情页面
- ✅ 图书搜索功能
- ✅ 图书详情查看

### 购物车模块

- ✅ 添加商品到购物车
- ✅ 更新购物车商品数量
- ✅ 删除购物车商品
- ✅ 批量操作购物车

### 订单模块

- ✅ 创建订单（直接购买和购物车结算）
- ✅ 订单列表查询
- ✅ 订单详情查看
- ✅ 订单支付（支付宝集成）
- ✅ 确认收货和取消订单

### 库存管理

- ✅ 库存查询和更新
- ✅ 库存预警机制
- ✅ 库存状态自动管理

### 管理员功能

- ✅ 管理员登录和权限管理
- ✅ 图书管理（添加、编辑、删除）
- ✅ 订单管理
- ✅ 用户管理
- ✅ 库存报表生成
- ✅ 缓存监控和管理

### 系统特色

- ✅ 多级缓存系统，提升性能
- ✅ 完善的安全机制（XSS防护、会话固定保护等）
- ✅ 自动化缓存预热
- ✅ 邮件通知系统
- ✅ JMX监控支持
- ✅ 热部署支持，提升开发效率
- ✅ 完善的日志记录

## 快速开始

### 环境要求

- JDK 17+
- Maven 3.6+
- MySQL 8.0+
- Tomcat 10.1+

### 部署步骤

#### 1. 克隆项目

```bash
git clone [仓库地址]
cd 23class4-goods
```

#### 2. 配置数据库

1. 创建数据库

```sql
CREATE DATABASE goods DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. 导入数据库脚本

```bash
mysql -u root -p goods < goods.sql
```

3. 修改数据库配置
   编辑 `src/main/resources/application.properties` 文件，修改数据库连接信息：

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/goods?useUnicode=true&characterEncoding=utf-8&serverTimezone=Asia/Shanghai
spring.datasource.username=root
spring.datasource.password=您的数据库密码
```

#### 3. 配置邮件服务

编辑 `src/main/resources/application.properties` 文件，修改邮件发送配置：

```properties
# 邮件配置
spring.mail.host=smtp.example.com
spring.mail.port=587
spring.mail.username=您的邮箱地址
spring.mail.password=您的邮箱密码
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
```

#### 4. 配置支付宝（可选）

如果需要支付功能，需配置支付宝相关参数。

#### 5. 构建和运行

##### 方式一：使用Maven运行

```bash
mvn spring-boot:run
```

##### 方式二：打包成WAR部署到Tomcat

```bash
mvn clean package
```

将生成的 `target/23class4-goods-1.0.war` 文件复制到Tomcat的 `webapps` 目录下，然后启动Tomcat。

#### 6. 访问系统

- **前台系统**: `http://localhost:8080/goods/`
- **后台管理**: `http://localhost:8080/goods/admin/login`
- **API文档**: `http://localhost:8080/goods/swagger-ui.html`

## 项目结构

```
src/
├── main/
│   ├── java/com/gg/goods/
│   │   ├── controller/          # 控制器层
│   │   │   ├── admin/           # 管理员控制器
│   │   │   └── ...              # 普通用户控制器
│   │   ├── config/              # 配置类
│   │   ├── entity/              # 实体类
│   │   ├── filters/             # 过滤器
│   │   ├── listener/            # 监听器
│   │   ├── mapper/              # MyBatis映射接口
│   │   ├── povos/               # 视图对象
│   │   ├── service/             # 服务层
│   │   │   └── impl/            # 服务实现类
│   │   ├── utils/               # 工具类
│   │   └── BasicApplication.java # Spring Boot启动类
│   ├── resources/
│   │   ├── mappers/             # MyBatis XML映射文件
│   │   ├── application.properties # 应用配置
│   │   └── application.yaml     # 应用配置（可选）
│   └── webapp/                  # Web资源
│       ├── jsps/                # JSP页面
│       ├── css/                 # CSS样式
│       ├── js/                  # JavaScript脚本
│       └── images/              # 图片资源
└── test/                        # 测试代码
```

## 核心模块说明

### 1. 用户模块

负责用户的注册、登录、信息管理等功能，包含邮箱验证机制和安全密码存储。

### 2. 商品模块

管理图书信息，提供分类浏览、搜索和详情查看功能。

### 3. 购物车模块

实现购物车的增删改查功能，支持商品数量调整和批量操作。

### 4. 订单模块

处理订单的创建、支付、查询和状态管理，集成支付宝支付功能。

### 5. 库存模块

管理商品库存，实现库存预警和自动状态更新。

### 6. 管理员模块

提供全面的后台管理功能，包括商品、订单、用户和系统设置等。

## 安全机制

- **密码加密**: 使用BCrypt进行密码加密存储
- **XSS防护**: 实现XSS过滤器，防止跨站脚本攻击
- **会话固定保护**: 防止会话固定攻击
- **输入验证**: 对所有用户输入进行严格验证
- **权限控制**: 实现基于角色的权限管理

## 缓存策略

系统使用Caffeine实现多级缓存机制：

- **分类缓存**: 缓存图书分类信息
- **商品缓存**: 缓存热门商品信息
- **库存缓存**: 缓存商品库存信息
- **用户缓存**: 缓存用户会话信息
- **页面缓存**: 缓存常用页面内容

缓存配置支持自动预热、过期策略和统计监控。

## 日志系统

项目使用多级日志记录：

- **业务日志**: 记录关键业务操作
- **错误日志**: 记录系统异常和错误
- **审计日志**: 记录安全相关操作
- **全量日志**: 记录所有系统活动

## 贡献指南

欢迎贡献代码！请遵循以下步骤：

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 开启 Pull Request

## 许可证

[MIT](https://choosealicense.com/licenses/mit/)
