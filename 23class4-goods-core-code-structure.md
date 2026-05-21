# 核心代码目录详细梳理

## 1. 项目核心结构概览

```
com.gg.goods/
├── config/              # 配置类
├── controller/          # 控制器层
├── entity/              # 实体类
├── filters/             # 过滤器
├── helpers/             # 工具类
├── mapper/              # 数据访问层
├── povos/               # 扩展实体类
├── service/             # 业务逻辑层
├── tags/                # 自定义标签
└── BasicApplication.java # 应用入口
```

## 2. 控制器层 (controller)

### 2.1 前台控制器

#### BookController.java

- **功能**：处理图书相关的前台请求
- **主要方法**：
    - `getBookByBid()`：获取图书详情
    - `getBooksByCase()`：多条件查询图书
    - `getNewestBooks()`：获取最新图书
    - `getHotBooks()`：获取热门图书
    - `index()`：首页展示

#### UserController.java

- **功能**：处理用户相关的前台请求
- **主要方法**：
    - `login()`：用户登录
    - `regist()`：用户注册
    - `editInfo()`：编辑用户信息
    - `changePassword()`：修改密码

#### CartController.java

- **功能**：处理购物车相关请求
- **主要方法**：
    - `addCart()`：添加商品到购物车
    - `listCart()`：查看购物车列表
    - `updateCartItem()`：更新购物车项
    - `deleteCartItem()`：删除购物车项

#### OrderController.java

- **功能**：处理订单相关请求
- **主要方法**：
    - `createOrder()`：创建订单
    - `orderDesc()`：查看订单详情
    - `listOrders()`：查看订单列表
    - `payOrder()`：支付订单

### 2.2 后台管理控制器

#### AdminBookController.java

- **功能**：后台图书管理
- **主要方法**：
    - `list()`：图书列表
    - `addPage()`：添加图书页面
    - `add()`：添加图书处理
    - `editPage()`：编辑图书页面
    - `edit()`：编辑图书处理

#### AdminUserController.java

- **功能**：后台用户管理
- **主要方法**：
    - `list()`：用户列表
    - `add()`：添加用户
    - `edit()`：编辑用户
    - `delete()`：删除用户

#### AdminOrderController.java

- **功能**：后台订单管理
- **主要方法**：
    - `list()`：订单列表
    - `updateStatus()`：更新订单状态
    - `updateAddress()`：更新订单地址

#### AdminStockController.java

- **功能**：后台库存管理
- **主要方法**：
    - `list()`：库存列表
    - `edit()`：编辑库存
    - `checkAndUpdateStockStatus()`：检查并更新库存状态

## 3. 实体类层 (entity)

### 核心实体类

#### Book.java

- **功能**：图书实体
- **主要属性**：
    - `bid`：图书ID
    - `bname`：图书名称
    - `author`：作者
    - `price`：定价
    - `currprice`：当前价格
    - `discount`：折扣
    - `press`：出版社
    - `publishtime`：出版时间
    - `imageW`：小图
    - `imageB`：大图

#### User.java

- **功能**：用户实体
- **主要属性**：
    - `uid`：用户ID
    - `username`：用户名
    - `password`：密码
    - `email`：邮箱
    - `phone`：电话
    - `address`：地址
    - `registtime`：注册时间

#### Order.java

- **功能**：订单实体
- **主要属性**：
    - `oid`：订单ID
    - `uid`：用户ID
    - `total`：总金额
    - `ordertime`：下单时间
    - `status`：订单状态
    - `address`：收货地址

#### Cart.java

- **功能**：购物车实体
- **主要属性**：
    - `cid`：购物车ID
    - `uid`：用户ID
    - `total`：购物车总金额

#### Stock.java

- **功能**：库存实体
- **主要属性**：
    - `sid`：库存ID
    - `bid`：图书ID
    - `currentStock`：当前库存
    - `minStock`：最低库存
    - `maxStock`：最高库存
    - `status`：库存状态

## 4. 数据访问层 (mapper)

### 核心Mapper接口

#### BookMapper.java

- **功能**：图书数据访问接口
- **主要方法**：
    - `selectByPrimaryKey()`：根据ID查询图书
    - `selectBooksByCase()`：多条件查询图书
    - `selectNewestBooks()`：查询最新图书
    - `selectHotBooks()`：查询热门图书
    - `insert()`：插入图书
    - `updateByPrimaryKey()`：更新图书
    - `deleteByPrimaryKey()`：删除图书

#### UserMapper.java

- **功能**：用户数据访问接口
- **主要方法**：
    - `selectByUsername()`：根据用户名查询用户
    - `insert()`：插入用户
    - `updateByPrimaryKey()`：更新用户

#### OrderMapper.java

- **功能**：订单数据访问接口
- **主要方法**：
    - `selectByPrimaryKey()`：根据ID查询订单
    - `selectByUid()`：根据用户ID查询订单
    - `insert()`：插入订单
    - `updateStatus()`：更新订单状态

#### StockMapper.java

- **功能**：库存数据访问接口
- **主要方法**：
    - `selectByBid()`：根据图书ID查询库存
    - `updateStock()`：更新库存
    - `checkAndUpdateStockStatus()`：检查并更新库存状态

## 5. 业务逻辑层 (service)

### 核心Service接口

#### BookService.java

- **功能**：图书业务逻辑
- **主要方法**：
    - `getBookByBid()`：获取图书详情
    - `getBooksByCase()`：多条件查询图书
    - `createBook()`：创建图书
    - `updateBook()`：更新图书
    - `deleteBook()`：删除图书
    - `getNewestBooks()`：获取最新图书
    - `getHotBooks()`：获取热门图书

#### UserService.java

- **功能**：用户业务逻辑
- **主要方法**：
    - `login()`：用户登录
    - `regist()`：用户注册
    - `updateUserInfo()`：更新用户信息
    - `changePassword()`：修改密码

#### OrderService.java

- **功能**：订单业务逻辑
- **主要方法**：
    - `createOrder()`：创建订单
    - `findByOid()`：根据ID查询订单
    - `findOrdersByUid()`：根据用户ID查询订单
    - `payOrder()`：支付订单

#### CartService.java

- **功能**：购物车业务逻辑
- **主要方法**：
    - `addCart()`：添加商品到购物车
    - `getCartByUid()`：获取用户购物车
    - `updateCartItem()`：更新购物车项
    - `deleteCartItem()`：删除购物车项

## 6. 配置层 (config)

### 核心配置类

#### WebMvcConfig.java

- **功能**：Web MVC配置
- **主要配置**：
    - 注册XSS和CSRF过滤器
    - 配置静态资源访问
    - 配置视图解析器

#### CacheConfig.java

- **功能**：缓存配置
- **主要配置**：
    - 配置缓存管理器
    - 定义缓存策略

#### CacheWarmer.java

- **功能**：缓存预热
- **主要功能**：应用启动时预加载热门图书到缓存

#### MailConfig.java

- **功能**：邮件配置
- **主要配置**：
    - 邮件服务器配置
    - 邮件发送器配置

## 7. 过滤器层 (filters)

### 核心过滤器

#### XSSFilter.java

- **功能**：XSS攻击防护
- **主要方法**：
    - 过滤请求参数中的XSS攻击代码

#### CSRFFilter.java

- **功能**：CSRF攻击防护
- **主要方法**：
    - 验证CSRF令牌
    - 防止跨站请求伪造

## 8. 工具类层 (helpers)

### 核心工具类

#### Verify.java

- **功能**：验证工具类
- **主要方法**：
    - `validateEmail()`：验证邮箱格式
    - `validatePhone()`：验证手机号格式
    - `validateUsername()`：验证用户名格式

#### VerifyCode.java

- **功能**：验证码生成工具
- **主要方法**：
    - `generateCode()`：生成验证码
    - `generateImage()`：生成验证码图片

## 9. 扩展实体类层 (povos)

### 核心扩展实体

#### CartBookPovo.java

- **功能**：购物车图书扩展类
- **主要属性**：
    - 包含Cartitem和Book的属性
    - 用于购物车列表展示

#### CategoryPovo.java

- **功能**：分类扩展类
- **主要属性**：
    - 包含分类和子分类信息
    - 用于分类树展示

#### StockVO.java

- **功能**：库存视图对象
- **主要属性**：
    - 包含图书信息和库存信息
    - 用于库存管理页面展示

## 10. 自定义标签层 (tags)

### 核心自定义标签

#### CSRFTokenTag.java

- **功能**：CSRF令牌标签
- **主要功能**：在JSP页面生成CSRF令牌
- **使用示例**：`<csrf:token />`

## 11. 应用入口 (BasicApplication.java)

- **功能**：Spring Boot应用入口类
- **主要注解**：
    - `@SpringBootApplication`：启动Spring Boot应用
    - `@MapperScan`：扫描Mapper接口
    - `@ComponentScan`：扫描组件
- **主要方法**：
    - `main()`：应用启动入口

## 12. 核心业务流程

### 12.1 图书详情查看流程

1. 用户访问 `/book/getBookByBid?bid=xxx`
2. BookController.getBookByBid() 调用 BookService.getBookByBid()
3. BookService 调用 BookMapper.selectByPrimaryKey() 获取图书信息
4. 将图书信息添加到Model中
5. 跳转到 `jsps/book/desc.jsp` 页面
6. 页面使用 `<c:url value='/${book.imageW}'/>` 生成图片URL

### 12.2 用户下单流程

1. 用户在购物车页面点击"结算"
2. CartController.createOrder() 调用 OrderService.createOrder()
3. OrderService 创建订单并保存到数据库
4. 清空购物车
5. 跳转到订单成功页面

### 12.3 订单支付流程

1. 用户在订单列表点击"支付"
2. OrderController.payOrder() 调用 OrderService.payOrder()
3. 处理支付逻辑
4. 更新订单状态
5. 跳转到支付成功页面



