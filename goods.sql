/*
 Navicat Premium Data Transfer

 Source Server         : Silas
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42)
 Source Host           : localhost:3306
 Source Schema         : goods

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42)
 File Encoding         : 65001

 Date: 28/12/2025 23:30:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `adminId` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `adminname` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `adminpwd` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`adminId`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES ('a1', 'liuBei', '123456');
INSERT INTO `admin` VALUES ('a2', 'guanYu', '123456');
INSERT INTO `admin` VALUES ('a3', 'zhangSanFei', '123456');

-- ----------------------------
-- Table structure for book
-- ----------------------------
DROP TABLE IF EXISTS `book`;
CREATE TABLE `book`  (
  `bid` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `bname` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `author` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `price` decimal(8, 2) NULL DEFAULT NULL,
  `currPrice` decimal(8, 2) NULL DEFAULT NULL,
  `discount` decimal(3, 1) NULL DEFAULT NULL,
  `press` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `publishtime` char(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `edition` int NULL DEFAULT NULL,
  `pageNum` int NULL DEFAULT NULL,
  `wordNum` int NULL DEFAULT NULL,
  `printtime` char(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `booksize` int NULL DEFAULT NULL,
  `paper` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `cid` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `image_w` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `image_b` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `shunxu` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`bid`) USING BTREE,
  INDEX `orderBy`(`shunxu` ASC) USING BTREE,
  INDEX `FK_t_book_t_category`(`cid` ASC) USING BTREE,
  CONSTRAINT `FK_t_book_t_category` FOREIGN KEY (`cid`) REFERENCES `category` (`cid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of book
-- ----------------------------
INSERT INTO `book` VALUES ('000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', '贾蓓', 79.80, 55.10, 6.9, '清华大学出版社', '2013-7-1', 1, 640, 1030000, '2013-7-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23268958-1_w.jpg', 'book_img/23268958-1_b.jpg', 16);
INSERT INTO `book` VALUES ('0BE0707984014E66BD9F34F534FCE0F7', 'OSGi实战【OSGi规范制定者亲自撰写 汇集Apache项目技术实战经验】', 'Richard', 99.00, 68.30, 6.9, '人民邮电出版社', '2013-1-1', 1, 468, 721000, '2013-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22938396-1_w.jpg', 'book_img/22938396-1_b.jpg', 58);
INSERT INTO `book` VALUES ('0EE8A0AE69154287A378FB110FF2C780', 'Java核心技术：卷Ⅰ基础知识（原书第8版）', '昊斯特曼', 98.00, 67.60, 6.9, '机械工业出版社', '2008-6-1', 1, 694, 0, '2008-6-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20285763-1_w.jpg', 'book_img/20285763-1_b.jpg', 12);
INSERT INTO `book` VALUES ('113D0D1BB9174DD19A7DE7E2B37F677F', 'Java7入门经典（跟编程导师Ivor Horton学Java 预计到货日期9月初）', '霍尔顿', 118.00, 81.40, 6.9, '清华大学出版社', '2012-8-1', 1, 1124, 1918000, '2012-8-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22813026-1_w.jpg', 'book_img/22813026-1_b.jpg', 94);
INSERT INTO `book` VALUES ('1286B13F0EA54E4CB75434762121486A', 'Java核心技术 卷I：基础知识(第9版·英文版)(上、下册)', '霍斯特曼', 109.00, 75.20, 6.9, '人民邮电出版社', '2013-7-1', 1, 0, 1197000, '2013-7-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23280479-1_w.jpg', 'book_img/23280479-1_b.jpg', 65);
INSERT INTO `book` VALUES ('13EBF9B1FDE346A683A1C45BD6773ECB', 'Java开发实战1200例（第Ⅱ卷）（史上最全的“编程实例”类图书，代码分析、实例速查、练习巩固的绝好帮手）', '无', 99.00, 68.30, 6.9, '清华大学出版社', '0', 1, 0, 1754000, '2011-6-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/21110930-1_w_1.jpg', 'book_img/21110930-1_b.jpg', 83);
INSERT INTO `book` VALUES ('1A15DC5E8A014A58862ED741D579B530', 'Java深入解析——透析Java本质的36个话题', '梁勇', 49.00, 33.80, 6.9, '电子工业出版社', '2013-11-1', 1, 298, 424000, '2013-11-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23363997-1_w_1.jpg', 'book_img/23363997-1_b.jpg', 86);
INSERT INTO `book` VALUES ('210A3DCA429049C78B623C3986BEB136', 'JavaScript经典教程套装：JavaScript高级程序设计(第3版)+JavaScript DOM编程艺术(第2版)(套装共2册)(超值附赠《码农》光盘1张)', 'Nicholas C. Zakas', 148.00, 86.80, 5.9, '人民邮电出版社', '2013-4-1', 1, 1048, 0, '2013-4-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23224089-1_w.jpg', 'book_img/23224089-1_b.jpg', 93);
INSERT INTO `book` VALUES ('22234CECF15F4ECB813F0B433DDA5365', 'JavaScript从入门到精通（附光盘1张）（连续8月JavaScript类全国零售排行前2名，13小时视频，400个经典实例、369项面试真题、138项测试史上最全资源库）', '明日科技', 69.80, 48.20, 6.9, '清华大学出版社', '2012-9-1', 1, 532, 939000, '2012-9-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22862057-1_w.jpg', 'book_img/22862057-1_b.jpg', 20);
INSERT INTO `book` VALUES ('230A00EC22BF4A1DBA87C64800B54C8D', 'Struts2技术内幕：深入解析Struts架构设计与实现原理', '陆舟', 69.00, 47.60, 6.9, '机械工业出版社', '2012-1-1', 1, 379, 0, '2012-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22577578-1_w.jpg', 'book_img/22577578-1_b.jpg', 56);
INSERT INTO `book` VALUES ('260F8A3594F741C1B0EB69616F65045B', 'Tomcat与Java Web开发技术详解（第2版）(含光盘1张)', '孙卫琴', 79.50, 54.90, 6.9, '电子工业出版社', '2009-1-1', 1, 734, 1216000, '2009-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20420983-1_w.jpg', 'book_img/20420983-1_b.jpg', 74);
INSERT INTO `book` VALUES ('28A03D28BAD449659A77330BE35FCD65', 'JAVA核心技术卷II：高级特性（原书第8版）', '霍斯特曼', 118.00, 81.40, 6.9, '机械工业出版社', '2008-12-1', 1, 852, 0, '2008-12-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20446562-1_w.jpg', 'book_img/20446562-1_b.jpg', 18);
INSERT INTO `book` VALUES ('2EE1A20A6AF742E387E18619D7E3BB94', 'Java虚拟机并发编程(Java并发编程领域的里程碑之作，资深Java技术专家、并发编程专家、敏捷开发专家和Jolt大奖得主撰写，Amazon五星畅销书)', 'Venkat Subramaniam', 59.00, 40.70, 6.9, '机械工业出版社', '2013-5-1', 1, 215, 0, '2013-5-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23239786-1_w.jpg', 'book_img/23239786-1_b.jpg', 54);
INSERT INTO `book` VALUES ('33ACF97A9A374352AE9F5E89BB791262', '基于MVC的JavaScript Web富应用开发', '麦卡劳', 59.00, 40.70, 6.9, '电子工业出版社', '2012-5-1', 1, 282, 462000, '2012-5-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22757564-1_w.jpg', 'book_img/22757564-1_b.jpg', 34);
INSERT INTO `book` VALUES ('37F75BEAE1FE46F2B14674923F1E7987', '数据结构与算法分析Java语言描述 第2版', '韦斯', 55.00, 38.00, 6.9, '机械工业出版社', '2009-1-1', 2, 440, 0, '2009-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20417467-1_w.jpg', 'book_img/20417467-1_b.jpg', 32);
INSERT INTO `book` VALUES ('39F1D0803E8F4592AE1245CACE683214', 'Java程序员修炼之道', '埃文斯', 89.00, 61.40, 6.9, '人民邮电出版社', '2013-8-1', 1, 395, 658000, '2013-8-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23301847-1_w_1.jpg', 'book_img/23301847-1_b.jpg', 36);
INSERT INTO `book` VALUES ('3AE5C8B976B6448A9D3A155C1BDE12BC', '深入理解Java虚拟机:JVM高级特性与最佳实践（超级畅销书，6个月5次印刷，从实践角度解析JVM工作原理，Java程序员必备）', '周志明', 69.00, 47.60, 6.9, '机械工业出版社', '0', 1, 0, 0, '2011-7-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/21108671-1_w_1.jpg', 'book_img/21108671-1_b.jpg', 66);
INSERT INTO `book` VALUES ('3DD187217BF44A99B86DD18A4DC628BA', 'Java核心技术 卷1 基础知识（原书第9版）', '霍斯特曼，科内尔', 119.00, 82.10, 6.9, '机械工业出版社', '2014-1-1', 1, 704, 0, '2014-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23362142-1_w_1.jpg', 'book_img/23362142-1_b.jpg', 9);
INSERT INTO `book` VALUES ('3E1990E19989422E9DA735978CB1E4CE', 'Effective Java中文版(第2版)', '布洛克', 52.00, 35.90, 6.9, '机械工业出版社', '2009-1-1', 2, 287, 0, '2009-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20459091-1_w.jpg', 'book_img/20459091-1_b.jpg', 25);
INSERT INTO `book` VALUES ('400D94DE5A0742B3A618FC76DF107183', 'JavaScript宝典（第7版）（配光盘）', '古德曼', 128.00, 88.30, 6.9, '清华大学出版社', '2013-1-1', 1, 1012, 1657000, '2013-1-1', 32, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23169892-1_w.jpg', 'book_img/23169892-1_b.jpg', 88);
INSERT INTO `book` VALUES ('4491EA4832E04B8B94F334B71E871983', 'Java语言程序设计：进阶篇（原书第8版）', '梁勇', 79.00, 54.50, 6.9, '机械工业出版社', '2011-6-1', 1, 507, 0, '2011-6-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/21117631-1_w_1.jpg', 'book_img/21117631-1_b.jpg', 48);
INSERT INTO `book` VALUES ('48BBFBFC07074ADE8CC906A45BE5D9A6', 'JavaScript权威指南（第6版）（淘宝前端团队倾情翻译！经典权威的JavaScript犀牛书！第6版特别涵盖了HTML5和ECMAScript5！）（经典巨著，当当独家首发）', '弗兰纳根', 139.00, 95.30, 6.9, '机械工业出版社', '2012-4-1', 1, 1004, 0, '2012-4-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22722790-1_w.jpg', 'book_img/22722790-1_b.jpg', 4);
INSERT INTO `book` VALUES ('49D98E7916B94232862F7DCD1B0BAB66', 'HTML5+JavaScript动画基础', '兰贝塔', 69.00, 47.60, 6.9, '人民邮电出版社', '2013-6-1', 1, 393, 553000, '2013-6-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23266633-1_w.jpg', 'book_img/23266633-1_b.jpg', 51);
INSERT INTO `book` VALUES ('4A9574F03A6B40C1B2A437237C17DEEC', 'Spring实战(第3版)（In Action系列中最畅销的Spring图书，近十万读者学习Spring的共同选择）', 'Craig Walls', 59.00, 40.70, 6.9, '人民邮电出版社', '2013-6-1', 1, 374, 487000, '2013-6-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23254532-1_w.jpg', 'book_img/23254532-1_b.jpg', 11);
INSERT INTO `book` VALUES ('4BF6D97DD18A4B77B8DED9B057577F8F', 'Java Web从入门到精通（附光盘1张）（连续8月Java类全国零售排行前2名，27小时视频，951个经典实例、369项面试真题、596项测试史上最全资源库）', '明日科技', 69.80, 48.20, 6.9, '清华大学出版社', '2012-9-1', 1, 547, 979000, '2012-9-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22862056-1_w.jpg', 'book_img/22862056-1_b.jpg', 23);
INSERT INTO `book` VALUES ('4c268b08206a4741a639538611fe5ab3', 'a', 'b', 99.00, 66.00, 6.7, 'c', '2023-01-01', 16, 999, 999999, '2023-01-01', 111, '4A', '56AD72718C524147A2485E5F4A95A062', 'book_img/696673-1_b.jpg', 'book_img/696673-1_w.jpg', 98);
INSERT INTO `book` VALUES ('4C3331CAD5A5453787A94B8D7CCEAA29', 'Java Web整合开发王者归来（JSP+Servlet+Struts+Hibernate+Spring）（配光盘', '刘京华', 99.80, 68.90, 6.9, '清华大学出版社', '2010-1-1', 1, 1010, 1368000, '2010-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20756351-1_w_1.jpg', 'book_img/20756351-1_b_1.jpg', 17);
INSERT INTO `book` VALUES ('4D20D2450B084113A331D909FF4975EB', 'jQuery实战(第2版)(畅销书升级版，掌握Web开发利器必修宝典)', 'Bear Bibeault　Yehuda Katz ', 69.00, 47.60, 6.9, '人民邮电出版社', '2012-3-1', 1, 394, 617000, '2012-3-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22638286-1_w.jpg', 'book_img/22638286-1_b.jpg', 79);
INSERT INTO `book` VALUES ('4E44405DAFB7413E8A13BBFFBEE73AC7', 'JavaScript经典实例', '鲍尔斯', 78.00, 53.80, 6.9, '中国电力出版社', '2012-3-1', 1, 512, 625000, '2012-3-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22692811-1_w.jpg', 'book_img/22692811-1_b.jpg', 68);
INSERT INTO `book` VALUES ('504FB999B0444B339907090927FDBE8A', '深入浅出Ext JS(第3版)', '徐会生', 69.00, 47.60, 6.9, '人民邮电出版社', '2013-10-1', 3, 413, 642000, '2013-10-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23351049-1_w_1.jpg', 'book_img/23351049-1_b.jpg', 71);
INSERT INTO `book` VALUES ('52077C8423B645A9BADA96A5E0B14422', 'Spring源码深度解析', '郝佳', 69.00, 47.60, 6.9, '人民邮电出版社', '2013-9-1', 1, 386, 545000, '2013-8-30', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23329703-1_w_1.jpg', 'book_img/23329703-1_b.jpg', 52);
INSERT INTO `book` VALUES ('52B0EDFF966E4A058BDA5B18EEC698C4', '亮剑Java Web项目开发案例导航(含DVD光盘1张)', '朱雪琴', 69.00, 41.40, 6.0, '电子工业出版社', '2012-3-1', 1, 526, 875000, '2012-3-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22623766-1_w.jpg', 'book_img/22623766-1_b.jpg', 81);
INSERT INTO `book` VALUES ('5315DA60D24042889400AD4C93A37501', 'Spring 3.x企业应用开发实战(含CD光盘1张)', '陈雄华', 90.00, 62.10, 6.9, '电子工业出版社', '2012-2-1', 1, 710, 1158000, '2012-2-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22605701-1_w.jpg', 'book_img/22605701-1_b.jpg', 24);
INSERT INTO `book` VALUES ('56B1B7D8CD8740B098677C7216A673C4', '疯狂 Java 程序员的基本修养（《疯狂Java讲义》最佳拍档，扫清知识死角，夯实基本功）', '李刚', 59.00, 40.70, 6.9, '电子工业出版社', '2013-1-1', 1, 484, 7710000, '2013-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23042420-1_w.jpg', 'book_img/23042420-1_b.jpg', 89);
INSERT INTO `book` VALUES ('57B6FF1B89C843C38BA39C717FA557D6', '了不起的Node.js: 将JavaScript进行到底（Web开发首选实时 跨多服务器 高并发）', 'Guillermo Rauch', 79.00, 54.50, 6.9, '电子工业出版社', '2014-1-1', 1, 292, 436000, '2014-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23368351-1_w_2.jpg', 'book_img/23368351-1_b.jpg', 8);
INSERT INTO `book` VALUES ('5a4438a94b514157b0aefdb45f0d6cb7', '阿萨姆奶茶', '蒋介石', 99.00, 22.00, 2.2, '国民党', '1925-01-01', 1, NULL, 9999, '1925-01-01', 1, '胶版纸', 'C8E274EE5C99499080A98E24F0BD2E03', 'book_img/23224089-1_w.jpg', 'book_img/696673-1_b.jpg', 103);
INSERT INTO `book` VALUES ('5C4A6F0F4A3B4672AD8C5F89BF5D37D2', 'Java从入门到精通（第3版）（附光盘1张）（连续8月Java类全国零售排行前2名，32小时视频，732个经典实例、369项面试真题、616项测试史上最全资源库）', '明日科技', 59.80, 41.30, 6.9, '清华大学出版社', '2012-9-1', 3, 564, 1013000, '2012-9-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22862060-1_w.jpg', 'book_img/22862060-1_b.jpg', 1);
INSERT INTO `book` VALUES ('5C68141786B84A4CB8929A2415040739', 'JavaScript高级程序设计(第3版)(JavaScript技术名著，国内JavasScript第一书，销量超过8万册)', 'Nicholas C. Zakas', 99.00, 68.30, 6.9, '人民邮电出版社', '2012-3-1', 1, 730, 1092000, '2012-3-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22628333-1_w.jpg', 'book_img/22628333-1_b.jpg', 5);
INSERT INTO `book` VALUES ('5EDB981339C342ED8DB17D5A198D50DC', 'Java程序性能优化', '葛一鸣', 59.00, 40.70, 6.9, '清华大学出版社', '2012-10-1', 1, 400, 649000, '2012-10-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22881618-1_w.jpg', 'book_img/22881618-1_b.jpg', 27);
INSERT INTO `book` VALUES ('6398A7BA400D40258796BCBB2B256068', 'JavaScript设计模式', 'Addy Osmani', 49.00, 33.80, 6.9, '人民邮电出版社', '2013-6-1', 1, 241, 301000, '2013-6-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23266635-1_w.jpg', 'book_img/23266635-1_b.jpg', 40);
INSERT INTO `book` VALUES ('676B56A612AF4E968CF0F6FFE289269D', 'JavaScript和jQuery实战手册（原书第2版）', '麦克法兰', 99.00, 68.30, 6.9, '机械工业出版社', '2013-3-11', 1, 504, 0, '2013-3-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23201813-1_w.jpg', 'book_img/23201813-1_b.jpg', 42);
INSERT INTO `book` VALUES ('7917F5B19A0948FD9551932909328E4E', 'Java项目开发案例全程实录（第2版）（配光盘）（软件项目开发全程实录丛书）', '明日科技', 69.80, 48.20, 6.9, '清华大学出版社', '2011-1-1', 2, 605, 1037000, '2011-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20991549-1_w_1.jpg', 'book_img/20991549-1_b.jpg', 64);
INSERT INTO `book` VALUES ('7C0C785FFBEC4DEC802FA36E8B0BC87E', '深入分析Java Web技术内幕', '许令波', 69.00, 47.60, 6.9, '电子工业出版社', '2012-9-1', 1, 442, 746000, '2012-9-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22881803-1_w.jpg', 'book_img/22881803-1_b.jpg', 50);
INSERT INTO `book` VALUES ('7CD79C20258F477AB841518D9312E843', 'Java程序员面试宝典（第三版）', '欧立奇', 49.00, 33.80, 6.9, '电子工业出版社', '2013-9-1', 1, 359, 446400, '2013-9-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23348683-1_w_1.jpg', 'book_img/23348683-1_b.jpg', 44);
INSERT INTO `book` VALUES ('7d1bde590ed24642ba76d18d158ff6e0', 'a', 'b', 99.00, 66.00, 6.7, 'c', '2023-01-01', 1, 999, 9999, '2023-01-01', 6, '6', 'C3F9FAAF4EA64857ACFAB0D9C8D0E446', 'book_img/696673-1_b.jpg', 'book_img/696673-1_w.jpg', 100);
INSERT INTO `book` VALUES ('7D7FE81293124793BDB2C6FF1F1C943D', '21天学通Java(第6版)（中文版累计销量超30000册）', 'Rogers Cadenhead', 55.00, 38.00, 6.9, '人民邮电出版社', '2013-4-1', 1, 410, 781000, '2013-4-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23219731-1_w.jpg', 'book_img/23219731-1_b.jpg', 46);
INSERT INTO `book` VALUES ('7FD7F50B15F74248AA769798909F8653', 'Java网络编程（第3版）——O’Reilly Java系列', '哈诺德', 85.00, 51.00, 6.0, '中国电力出版社', '2005-11-1', 1, 718, 668000, '2005-11-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/9062293-1_w.jpg', 'book_img/9062293-1_b.jpg', 35);
INSERT INTO `book` VALUES ('819FF56E4423462394E6F83882F78975', '学通Java Web的24堂课（配光盘）（软件开发羊皮卷）', '陈丹丹', 79.80, 55.10, 6.9, '清华大学出版社', '2011-6-1', 1, 718, 1488000, '2011-6-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/21118835-1_w_1.jpg', 'book_img/21118835-1_b.jpg', 91);
INSERT INTO `book` VALUES ('81FADA99309342F4978D5C680B0C6E8C', 'Java入门很简单（配光盘）（入门很简单丛书）（打开Java编程之门 Java技术网推荐）', '李世民', 59.80, 41.30, 6.9, '清华大学出版社', '2012-8-1', 1, 459, 745000, '2012-8-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22839309-1_w.jpg', 'book_img/22839309-1_b.jpg', 85);
INSERT INTO `book` VALUES ('89A57D099EA14026A5C3D10CFC10C22C', 'Java 2实用教程（第4版）（21世纪高等学校计算机基础实用规划教材）', '耿祥义', 39.50, 31.60, 8.0, '清华大学出版社', '2012-8-1', 4, 479, 782000, '2012-8-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22844118-1_w.jpg', 'book_img/22844118-1_b.jpg', 73);
INSERT INTO `book` VALUES ('8A5B4042D5B14D6B87A34DABF327387F', 'Java核心技术 卷II：高级特性(第9版·英文版)(上、下册)', '霍斯特曼', 119.00, 82.10, 6.9, '人民邮电出版社', '2013-7-1', 1, 1118, 1370000, '2013-7-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23280478-1_w.jpg', 'book_img/23280478-1_b.jpg', 57);
INSERT INTO `book` VALUES ('8b2e3d0a15b947fabde5a3ef571af4d6', 'a', 'b', 99.00, 66.00, 6.7, 'c', '2023-01-01', 1, 9999, 999999, '2023-01-01', 11, '6', 'C4DD8CA232864B31A367EE135D86382C', 'book_img/696673-1_b.jpg', 'book_img/696673-1_w.jpg', 99);
INSERT INTO `book` VALUES ('8DD0ADF2665B40899E09ED2983DC3F7B', 'jQuery权威指南（被公认的权威的、易学的jQuery实战教程，多次重印，热销中）', '陶国荣', 59.00, 40.70, 6.9, '机械工业出版社', '2011-1-1', 1, 385, 0, '2011-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/21006995-1_w_1.jpg', 'book_img/21006995-1_b.jpg', 75);
INSERT INTO `book` VALUES ('8E16D59BA4C34374A68029AE877613C4', '轻量级Java EE企业应用实战（第3版）：Struts 2＋Spring 3＋Hibernate整合开发(含CD光盘1张)', '李刚', 99.00, 68.30, 6.9, '电子工业出版社', '2012-4-1', 1, 816, 1440000, '2012-4-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22685703-1_w.jpg', 'book_img/22685703-1_b.jpg', 6);
INSERT INTO `book` VALUES ('8F1520F2CED94C679433B9C109E791CB', 'Java从入门到精通（实例版）（附光盘1张）（连续8月Java类全国零售排行前2名，14小时视频，732个经典实例、369项面试真题、616项测试史上最全资源库）', '明日科技', 69.80, 47.60, 6.9, '清华大学出版社', '2012-9-1', 1, 548, 986000, '2012-9-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22862061-1_w.jpg', 'book_img/22862061-1_b.jpg', 49);
INSERT INTO `book` VALUES ('90E423DBE56042838806673DB3E86BD3', '《Spring技术内幕（第2版）》（畅销书全新升级，Spring类图书销量桂冠，从宏观和微观两个角度解析Spring架构设计和实现原理）', '计文柯', 69.00, 47.60, 6.9, '机械工业出版社', '2012-2-1', 2, 399, 0, '2012-2-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22606836-1_w.jpg', 'book_img/22606836-1_b.jpg', 45);
INSERT INTO `book` VALUES ('926B8F31C5D04F61A72F66679A0CCFFD', 'JavaScript编程精解（华章程序员书库）（JavaScript之父高度评价并强力推荐，系统学习JS首选！）', '哈弗贝克', 49.00, 33.80, 6.9, '械工业出版社', '2012-9-1', 1, 162, 0, '2012-9-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22873894-1_w.jpg', 'book_img/22873894-1_b.jpg', 70);
INSERT INTO `book` VALUES ('95AACC68D64D4D67B1E33E9EAC22B885', 'Head First Java（中文版）（JAVA经典畅销书 生动有趣 轻松学好JAVA）', '塞若', 79.00, 47.40, 6.0, '中国电力出版社', '2007-2-1', 1, 689, 983000, '2001-7-2', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/9265169-1_w.jpg', 'book_img/9265169-1_b.jpg', 13);
INSERT INTO `book` VALUES ('97437DAD03FA456AA7D6154614A43B55', 'HTML、CSS、JavaScript网页制作从入门到精通（两万读者的选择，经久不衰的超级畅销书最新升级版！网页制作学习者入门必读经典！）', '刘西杰', 49.00, 32.90, 6.7, '人民邮电出版社', '2012-12-24', 1, 450, 705000, '2012-12-24', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22928649-1_w.jpg', 'book_img/22928649-1_b.jpg', 3);
INSERT INTO `book` VALUES ('9923901FBF124623BC707920D8936BC8', 'JavaScript DOM编程艺术(第2版)', '基思', 49.00, 33.80, 6.9, '人民邮电出版社', '2011-4-1', 1, 286, 443000, '2011-4-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/21049601-1_w_1.jpg', 'book_img/21049601-1_b.jpg', 28);
INSERT INTO `book` VALUES ('99BF63AC12AD48FCB673F1820888964E', 'Java Web开发实战1200例（第Ⅱ卷）（史上最全的“编程实例”类图书，代码分析、实例速查、练习巩固的绝好帮手）', '无', 99.00, 67.40, 6.8, '清华大学出版社', '0', 0, 0, 1746000, '2011-6-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/21110929-1_w_1.jpg', 'book_img/21110929-1_b.jpg', 78);
INSERT INTO `book` VALUES ('9D257176A6934CB79427CEC37E69249F', '疯狂Ajax讲义（第3版）--jQuery/Ext JS/Prototype/DWR企业应用前端开发实战(含CD光盘1张)（畅销书升级版，企业应用前端开发实战指南）', '李刚', 79.00, 54.50, 6.9, '电子工业出版社', '2013-2-1', 1, 624, 997000, '2013-2-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23184673-1_w.jpg', 'book_img/23184673-1_b.jpg', 53);
INSERT INTO `book` VALUES ('9FBD51A7C02D4F5B9862CD2EBBF5CA04', 'Flash ActionScript 3.0全站互动设计', '刘欢 ', 69.80, 48.20, 6.9, '人民邮电出版社', '2012-10-1', 1, 488, 760000, '2012-10-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22886581-1_w.jpg', 'book_img/22886581-1_b.jpg', 96);
INSERT INTO `book` VALUES ('9FF423101836438F874035A48498CF45', 'Java编程思想（英文版·第4版）', '埃克尔 ', 79.00, 54.50, 6.9, '机械工业出版社', '2007-4-1', 1, 1482, 0, '2007-4-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/9288920-1_w.jpg', 'book_img/9288920-1_b.jpg', 31);
INSERT INTO `book` VALUES ('A3D464D1D1344ED5983920B472826730', 'Java Web开发详解：XML+DTD+XML Schema+XSLT+Servlet 3 0+JSP 2 2深入剖析与实例应用(含CD光盘1张)', '孙鑫', 119.00, 61.30, 5.2, '电子工业出版社', '2012-5-1', 1, 889, 1760000, '2012-5-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22788412-1_w.jpg', 'book_img/22788412-1_b.jpg', 60);
INSERT INTO `book` VALUES ('A46A0F48A4F649AE9008B38EA48FAEBA', 'Java编程全能词典(含DVD光盘2张)', '明日科技', 98.00, 65.70, 6.7, '电子工业出版社', '2010-3-1', 1, 486, 496000, '2010-3-1', 32, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20813806-1_w_1.jpg', 'book_img/20813806-1_b.jpg', 90);
INSERT INTO `book` VALUES ('A5A6F27DCD174614850B26633A0B4605', 'JavaScript模式', '斯特凡洛夫', 38.00, 22.80, 6.0, '中国电力出版社', '2012-7-1', 1, 208, 253000, '2012-7-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22819430-1_w.jpg', 'book_img/22819430-1_b.jpg', 61);
INSERT INTO `book` VALUES ('A7220EF174704012830E066FDFAAD4AD', 'Spring 3.0就这么简单（国内原创的Java敏捷开发图书，展现作者Spring原创开源项目ROP开发的全过程，所有项目工程均以Maven组织）', '陈雄华', 59.00, 40.70, 6.9, '人民邮电出版社', '2013-1-1', 1, 380, 530000, '2013-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22938474-1_w.jpg', 'book_img/22938474-1_b.jpg', 77);
INSERT INTO `book` VALUES ('A7EFD99367C9434682A790635D3C5FDF', 'Java Web技术整合应用与项目实战（JSP+Servlet+Struts2+Hibernate+Spring3）', '张志锋', 98.00, 67.60, 6.9, '清华大学出版社', '2013-6-1', 1, 878, 0, '2013-6-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23266270-1_w.jpg', 'book_img/23266270-1_b.jpg', 92);
INSERT INTO `book` VALUES ('A8EF76FD21A645109538614DEA85F3F7', 'Java语言程序设计：基础篇（原书第8版）', '梁勇', 75.00, 51.80, 6.9, '机械工业出版社', '2011-6-1', 1, 586, 0, '2011-6-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/21122188-1_w_1.jpg', 'book_img/21122188-1_b.jpg', 30);
INSERT INTO `book` VALUES ('AD6EA79CCB8240AAAF5B292AD7E5DCAA', 'jQuery Mobile权威指南（根据jQuery Mobile最新版本撰写的权威参考书！全面讲解jQuery Mobile的所有功能、特性、使用方法和开发技巧）', '陶国荣', 59.00, 40.70, 6.9, '机械工业出版社', '2012-8-1', 1, 249, 0, '2012-8-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22847009-1_w.jpg', 'book_img/22847009-1_b.jpg', 38);
INSERT INTO `book` VALUES ('AE0935F13A214436B8599DE285A86220', 'JavaScript基础教程(第8版)(经典JavaScript入门书 涵盖Ajax和jQuery)', 'Tom Negrino　Dori Smith', 69.00, 47.60, 6.9, '人民邮电出版社', '2012-4-1', 1, 392, 694000, '2012-4-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22717349-1_w.jpg', 'book_img/22717349-1_b.jpg', 37);
INSERT INTO `book` VALUES ('aea5c8bd84cd4c559f288ca965c7001e', 'qqq', 'www', 666.00, 233.00, 3.5, 'eee', '2023-01-01', 1, 999, 9999, '2023-01-01', 8, '6', '56AD72718C524147A2485E5F4A95A062', 'book_img/696673-1_w.jpg', 'book_img/696673-1_b.jpg', 101);
INSERT INTO `book` VALUES ('AF28ED8F692C4288B32CF411CBDBFC23', '经典Java EE企业应用实战——基于WebLogic/JBoss的JSF+EJB 3+JPA整合开发(含CD光盘1张)', '无', 79.00, 54.50, 6.9, '电子工业出版社', '2010-8-1', 1, 0, 0, '2010-8-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20928547-1_w_1.jpg', 'book_img/20928547-1_b.jpg', 55);
INSERT INTO `book` VALUES ('B329A14DDEF8455F82B3FDF25821D2BB', '名师讲坛——Java Web开发实战经典基础篇（JSP、Servlet、Struts、Ajax）（32小时全真课堂培训，视频超级给力！390项实例及分析，北京魔乐科技培训中心Java Web全部精华）', '李兴华', 69.80, 48.20, 6.9, '清华大学出版社', '2010-8-1', 1, 554, 819000, '2010-8-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20915948-1_w_3.jpg', 'book_img/20915948-1_b.jpg', 22);
INSERT INTO `book` VALUES ('B7A7DA7A94E54054841EED1F70C3027C', '锋利的jQuery(第2版)(畅销书升级版，增加jQuery Mobile和性能优化)', '单东林', 49.00, 33.80, 6.9, '人民邮电出版社', '2012-7-1', 2, 380, 598000, '2012-7-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22786088-1_w.jpg', 'book_img/22786088-1_b.jpg', 10);
INSERT INTO `book` VALUES ('BD1CB005E4A04DCA881DA8689E21D4D0', 'jQuery UI开发指南', 'Eric Sarrion', 39.00, 26.90, 6.9, '人民邮电出版社', '2012-12-1', 1, 212, 286000, '2012-12-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22910975-1_w.jpg', 'book_img/22910975-1_b.jpg', 63);
INSERT INTO `book` VALUES ('C23E6E8A6DB94E27B6E2ABD39DC21AF5', 'JavaScript:The Good Parts(影印版）', '克罗克福特', 28.00, 19.30, 6.9, '东南大学出版社', '2009-1-1', 1, 153, 181000, '2009-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20412979-1_w.jpg', 'book_img/20412979-1_b.jpg', 95);
INSERT INTO `book` VALUES ('C3CF52B3ED2D4187A16754551488D733', 'Java从入门到精通（附光盘）', '魔乐科技', 59.00, 35.40, 6.0, '人民邮电出版社', '2010-4-1', 1, 519, 884000, '2010-4-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20810282-1_w_1.jpg', 'book_img/20810282-1_b.jpg', 29);
INSERT INTO `book` VALUES ('C86D3F6FACB449BEBD940D9307ED4A47', '编写高质量代码：改善Java程序的151个建议(从语法、程序设计和架构、工具和框架、编码风格、编程思想5个方面探讨编写高质量Java代码的技巧、禁忌和最佳实践)', '秦小波', 59.00, 40.70, 6.9, '机械工业出版社', '2012-1-1', 1, 303, 0, '2012-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22579686-1_w.jpg', 'book_img/22579686-1_b.jpg', 84);
INSERT INTO `book` VALUES ('CB0AB3654945411EA69F368D0EA91A00', 'JavaScript语言精粹（修订版）', '道格拉斯·克罗克福德', 49.00, 39.20, 8.0, '电子工业出版社', '2012-9-1', 1, 155, 258000, '2012-9-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22872884-1_w.jpg', 'book_img/22872884-1_b.jpg', 33);
INSERT INTO `book` VALUES ('CD913617EE964D0DBAF20C60076D32FB', '名师讲坛——Java开发实战经典（配光盘）（60小时全真课堂培训，视频超级给力！790项实例及分析，北京魔乐科技培训中心Java全部精华）', '李兴华', 79.80, 55.10, 6.9, '清华大学出版社', '2009-8-1', 1, 831, 1222000, '2012-8-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20637368-1_w_2.jpg', 'book_img/20637368-1_b_2.jpg', 19);
INSERT INTO `book` VALUES ('CE01F15D435A4C51B0AD8202A318DCA7', 'Java编程思想（第4版）', '布鲁斯.艾克尔', 108.00, 74.50, 6.9, '机械工业出版社', '2007-6-1', 1, 880, 0, '2007-6-1', 0, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/9317290-1_w.jpg', 'book_img/9317290-1_b.jpg', 2);
INSERT INTO `book` VALUES ('CF5546769F2842DABB2EF7A00D51F255', 'jQuery开发从入门到精通（配套视频327节，中小实例232个，实战案例7个商品详情手册11部，网页模版83类）（附1DVD）', '袁江', 79.80, 55.10, 6.9, '清华大学出版社', '2013-6-1', 1, 619, 1109000, '2013-6-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23263012-1_w.jpg', 'book_img/23263012-1_b.jpg', 43);
INSERT INTO `book` VALUES ('D0DA36CEE42549FFB299B7C7129761D5', 'Java应用架构设计：模块化模式与OSGi(全球资深Java技术专家的力作，系统、全面地讲解如何将模块化设计思想引入开发中，涵盖18个有助于实现模块化软件架构的模式)', '克内恩席尔德', 69.00, 47.60, 6.9, '机械工业出版社', '2013-9-1', 1, 251, 0, '2013-9-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23339643-1_w.jpg', 'book_img/23339643-1_b.jpg', 26);
INSERT INTO `book` VALUES ('D0E69F85ACAB4C15BB40966E5AA545F1', 'Java并发编程实战（第16届Jolt大奖提名图书，Java并发编程必读佳作', 'Brian Goetz', 69.00, 47.60, 6.9, '机械工业出版社', '2012-2-1', 1, 290, 0, '2012-2-1', 32, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22606835-1_w.jpg', 'book_img/22606835-1_b.jpg', 15);
INSERT INTO `book` VALUES ('D2ABA8B06C524632846F27C34568F3CE', 'Java 经典实例', '达尔文', 98.00, 67.60, 6.9, '中国电力出版社', '2009-2-1', 1, 784, 805000, '2009-2-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20500255-1_w.jpg', 'book_img/20500255-1_b.jpg', 62);
INSERT INTO `book` VALUES ('D8723405BA054C13B52357B8F6AEEC24', '深入理解Java虚拟机：JVM高级特性与最佳实践（第2版）', '周志明', 79.00, 54.50, 6.9, '机械工业出版社', '2013-6-1', 2, 433, 0, '2013-6-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23259731-1_w.jpg', 'book_img/23259731-1_b.jpg', 14);
INSERT INTO `book` VALUES ('DC36FD53A1514312A0A9ADD53A583886', 'JavaScript异步编程：设计快速响应的网络应用【掌握JavaScript异步编程必杀技，让代码更具响应度！ 】', 'Trevor Burnham ', 32.00, 22.10, 6.9, '人民邮电出版社', '2013-6-1', 1, 118, 98000, '2013-5-23', 32, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23252196-1_w.jpg', 'book_img/23252196-1_b.jpg', 72);
INSERT INTO `book` VALUES ('DCB64DF0084E486EBF173F729A3A630A', 'Java设计模式(第2版)', 'Steven John Metsker', 75.00, 51.80, 6.9, '电子工业出版社', '2012-9-1', 1, 0, 0, '2012-9-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22868759-1_w.jpg', 'book_img/22868759-1_b.jpg', 76);
INSERT INTO `book` VALUES ('DEE7BDC7E0E343149E3C3601D2658171', '疯狂HTML 5/CSS 3/JavaScript讲义(含CD光盘1张)', '李刚', 69.00, 47.60, 6.9, '电子工业出版社', '2012-5-1', 1, 500, 819000, '2012-5-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22783904-1_w.jpg', 'book_img/22783904-1_b.jpg', 21);
INSERT INTO `book` VALUES ('DF4E74EEE89B43229BB8212F0B858C38', '精通Hibernate：Java对象持久化技术详解（第2版）(含光盘1张)', '孙卫琴', 75.00, 51.80, 6.9, '电子工业出版社', '2010-2-1', 1, 695, 1148800, '2010-2-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20773347-1_w_1.jpg', 'book_img/20773347-1_b.jpg', 39);
INSERT INTO `book` VALUES ('E4F184188C8B4C7BB32D4E76603426AC', '疯狂Java讲义（第2版，附光盘）', '李刚', 109.00, 75.20, 6.9, '电子工业出版社', '2012-1-1', 1, 844, 1747000, '2012-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22588603-1_w.jpg', 'book_img/22588603-1_b.jpg', 7);
INSERT INTO `book` VALUES ('EA695342393C4BE48B831FA5E6B0E5C4', '编写可维护的JavaScript《JavaScript高级程序设计》作者Nicholas Zakas最新力作，构建编码风格手册，帮助开发团队从“游击队”走向“正规军”）', 'Nicholas C. Zakas', 55.00, 38.00, 6.9, '人民邮电出版社', '2013-4-1', 1, 227, 400000, '2013-4-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23200995-1_w.jpg', 'book_img/23200995-1_b.jpg', 59);
INSERT INTO `book` VALUES ('F0E34313BF304CCEBF198BD4E05307B8', 'jQuery Cookbook中文版（jQuery之父鼎力推荐，社区数十位专家倾情力作', 'jQuery社区专家组', 69.00, 47.60, 6.9, '人民邮电出版社', '2013-5-1', 1, 425, 573000, '2013-5-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/23219358-1_w.jpg', 'book_img/23219358-1_b.jpg', 87);
INSERT INTO `book` VALUES ('F6162799E913423EA5CB57BEC65AB1E9', 'JUnit实战(第2版)', '塔凯文', 79.00, 54.50, 6.9, '人民邮电出版社', '2012-4-1', 1, 442, 640000, '2012-4-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22633574-1_w.jpg', 'book_img/22633574-1_b.jpg', 80);
INSERT INTO `book` VALUES ('F693239BC3B3444C8538ABE7411BB38E', 'Java Web典型模块与项目实战大全（配光盘）', '常建功', 99.50, 68.70, 6.9, '清华大学出版社', '2011-1-1', 1, 922, 1473000, '2011-1-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/20988080-1_w_1.jpg', 'book_img/20988080-1_b.jpg', 41);
INSERT INTO `book` VALUES ('F78C94641DB4475BBA1E72A07DF9B3AE', 'JAVA面向对象编程', '孙卫琴 ', 65.80, 45.40, 6.9, '电子工业出版社', '2006-7-1', 1, 625, 1030400, '2006-7-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/9186890-1_w.jpg', 'book_img/9186890-1_b.jpg', 69);
INSERT INTO `book` VALUES ('FC232CD9B6E6411BBBB1A5B781D2C3C9', 'Java与模式(含盘)（超多实例和习题，详解设计原则与设计模式）', '阎宏', 88.00, 60.70, 6.9, '电子工业出版社', '2002-10-1', 1, 1024, 16704000, '2002-10-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/696673-1_w.jpg', 'book_img/696673-1_b.jpg', 67);
INSERT INTO `book` VALUES ('FEC3740CF30E442A94021911A25EF0D7', 'Spring攻略(第2版)(Spring攻略(第2版))', 'Gary Mak　Josh Long　Daniel Rubio', 128.00, 88.30, 6.9, '人民邮电出版社', '2012-3-1', 1, 938, 1322000, '2012-3-1', 16, '胶版纸', '5F79D0D246AD4216AC04E9C5FAB3199E', 'book_img/22623020-1_w.jpg', 'book_img/22623020-1_b.jpg', 82);
INSERT INTO `book` VALUES ('FFABBED1E5254BC0B2726EC4ED8ACCDA', '深入理解OSGi：Equinox原理、应用与最佳实践（《深入理解Java虚拟机》作者新作！全面解读最新OSGi R5.0规范，深入讲解OSGi原理和服务，以及Equinox框架的用法和原理）', '周志明', 79.00, 54.50, 6.9, '机械工业出版社', '2013-2-1', 1, 414, 0, '2013-2-1', 16, '胶版纸', 'A9CFBED0F77746C5BD751F2502FAB2CD', 'book_img/23179003-1_w.jpg', 'book_img/23179003-1_b.jpg', 47);

-- ----------------------------
-- Table structure for cartitem
-- ----------------------------
DROP TABLE IF EXISTS `cartitem`;
CREATE TABLE `cartitem`  (
  `cartItemId` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `quantity` int NULL DEFAULT NULL,
  `bid` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `uid` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `shunxu` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`cartItemId`) USING BTREE,
  INDEX `orderBy`(`shunxu` ASC) USING BTREE,
  INDEX `FK_t_cartitem_t_user`(`uid` ASC) USING BTREE,
  INDEX `FK_t_cartitem_t_book`(`bid` ASC) USING BTREE,
  CONSTRAINT `FK_t_cartitem_t_book` FOREIGN KEY (`bid`) REFERENCES `book` (`bid`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_t_cartitem_t_user` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 53 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of cartitem
-- ----------------------------
INSERT INTO `cartitem` VALUES ('b51cd72427dceae875b9dda8692598ae', 1, '000A18FDB38F470DBE9CD0972BADB23F', '06B1374AAF244FF6804D4C4292693A80', 18);
INSERT INTO `cartitem` VALUES ('c56f72da19623279058136465942b115', 5, '210A3DCA429049C78B623C3986BEB136', 'c56f72da19623279058136465942a115', 12);
INSERT INTO `cartitem` VALUES ('db23e0c102188e6ea224381364d47089', 3, '000A18FDB38F470DBE9CD0972BADB23F', 'c56f72da19623279058136465942a115', 13);

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `cid` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `cname` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `pid` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `miaoshu` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `shunxu` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`cid`) USING BTREE,
  UNIQUE INDEX `cname`(`cname` ASC) USING BTREE,
  INDEX `FK_t_category_t_category`(`pid` ASC) USING BTREE,
  INDEX `orderBy`(`shunxu` ASC) USING BTREE,
  CONSTRAINT `FK_category` FOREIGN KEY (`pid`) REFERENCES `category` (`cid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES ('1', '程序设计', NULL, '程序设计分类', 1);
INSERT INTO `category` VALUES ('2', '办公室用书', NULL, '办公室用书', 2);
INSERT INTO `category` VALUES ('3', '图形 图像 多媒体', NULL, '图形图像多媒体', 3);
INSERT INTO `category` VALUES ('4', '操作系统/系统开发', NULL, '操作系统/系统开发', 4);
INSERT INTO `category` VALUES ('458795C27E7346A8A5F1B942319297E0', '系统开发', '4', '系统开发分类', 29);
INSERT INTO `category` VALUES ('4D01FFF0CB94468EA907EF42780668AB', '购买指南 组装指南 维修', '2', '购买指南 组装指南 维修分类', 18);
INSERT INTO `category` VALUES ('5', '数据库', NULL, '数据库', 5);
INSERT INTO `category` VALUES ('56AD72718C524147A2485E5F4A95A062', '3DS MAX', '3', '3DS MAX分类', 21);
INSERT INTO `category` VALUES ('57DE3C2DDA784B81844029A28217698C', 'Dreamweaver', '3', 'Dreamweaver分类', 24);
INSERT INTO `category` VALUES ('5F79D0D246AD4216AC04E9C5FAB3199E', 'Java Javascript', '1', 'Java Javascript分类', 10);
INSERT INTO `category` VALUES ('6', '网络与数据通讯', NULL, '网络与数据通讯!', 6);
INSERT INTO `category` VALUES ('65640549B80E40B1981CDEC269BFFCAD', 'Photoshop', '3', 'Photoshop分类', 20);
INSERT INTO `category` VALUES ('65830AB237EF428BAE9B7ADC78A8D1F6', 'Unix', '4', 'Unix分类', 28);
INSERT INTO `category` VALUES ('757BDAB506A445EC8DEDA4CE04303B9F', '网页设计', '3', '网页设计分类', 22);
INSERT INTO `category` VALUES ('84ECE401C2904DBEA560D04A581A66D9', 'HTML XML', '1', 'HTML XML分类', 13);
INSERT INTO `category` VALUES ('922E6E2DB04143D39C9DDB26365B3EE8', 'C C++ VC VC++', '1', 'C C++ VC VC++分类', 12);
INSERT INTO `category` VALUES ('96F209F79DB242E9B99CC1B98FAB01DB', '数据库理论', '5', '数据库理论分类', 33);
INSERT INTO `category` VALUES ('A9CFBED0F77746C5BD751F2502FAB2CD', '电子商务 电子政务', '6', '电子商务 电子政务分类', 35);
INSERT INTO `category` VALUES ('B596ECE0F9BF40288F40A66B35551806', 'Flush', '3', 'Flush分类', 23);
INSERT INTO `category` VALUES ('B92ED191DBE647BE8F75721FB231E207', '因特网 电子邮件', '2', '因特网 电子邮件分类', 19);
INSERT INTO `category` VALUES ('C3F9FAAF4EA64857ACFAB0D9C8D0E446', 'PHP', '1', 'PHP分类', 14);
INSERT INTO `category` VALUES ('C4DD8CA232864B31A367EE135D86382C', '计算机初级入门', '2', '计算机初级入门分类', 17);
INSERT INTO `category` VALUES ('C8E274EE5C99499080A98E24F0BD2E03', '.NET', '1', '.NET分类', 15);
INSERT INTO `category` VALUES ('D45D96DA359A4FEAB3AB4DCF2157FC06', 'JSP', '1', 'JSP分类', 11);
INSERT INTO `category` VALUES ('DCAD0384A6444C048951C7B36C5D96EE', 'Flash', '3', 'Flash分类', 25);
INSERT INTO `category` VALUES ('F4FBD087EB054CA1896093F172AC33D9', '数据仓库与数据挖掘', '5', '数据仓库与数据挖掘分类', 30);
INSERT INTO `category` VALUES ('F5C091B3967442A2B35EFEFC4EF8746F', '微软Office', '2', '微软Office分类', 16);
INSERT INTO `category` VALUES ('FAB7B7F7084F4D57A0808ADC61117683', 'Windows', '4', 'Windows分类', 26);

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`  (
  `oid` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `ordertime` datetime NULL DEFAULT NULL,
  `total` decimal(10, 2) NULL DEFAULT NULL,
  `status` int NULL DEFAULT NULL,
  `address` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `uid` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`oid`) USING BTREE,
  INDEX `FK_t_order_t_user`(`uid` ASC) USING BTREE,
  CONSTRAINT `FK_t_order_t_user` FOREIGN KEY (`uid`) REFERENCES `user` (`uid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES ('08E8E1C2D5E211EEA3AC002B67D6086B', '2024-02-28 10:35:28', 33.80, 1, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('1938A151A23D11EE99A4002B67D6086B', '2023-12-24 17:13:34', 143.90, 1, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('1A37C14DA23C11EE99A4002B67D6086B', '2023-12-24 17:06:26', 0.00, 1, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('21F89E5DD51811EEB516002B67D6086B', '2024-02-27 10:30:12', 6760.00, 1, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('2777C6EBA23E11EE99A4002B67D6086B', '2023-12-24 17:21:08', 123.40, 1, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('2785f803cced4fe580bcb760481f3b4e', '2025-12-21 23:37:23', 33.80, 3, '肇庆市  三卡拉区   三卡拉路    KLF 收', '3165a7333dbe45c78165b3f4db05c63f');
INSERT INTO `order` VALUES ('2e8f60c370044feca395e10b32f092f0', '2025-12-19 12:09:16', 67.60, 1, '肇庆市  三卡拉区   三卡拉路    KLF 收', '7733A909DC8C11F0B9D3B44506D77805');
INSERT INTO `order` VALUES ('308b444c71db4004ac4439b4dcce1d8b', '2025-12-19 10:34:19', 81.40, 1, '哈尔滨市  香坊区   赣水路    XXX 收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('471481f160ff44649c1c5244c75fbb0a', '2025-12-19 10:28:30', NULL, 1, '', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('474CDA8C36FE11F09334002B67D6086B', '2025-05-22 19:16:59', 638.60, 1, '广州市 从化区  华夏职业学院', '06B1374AAF244FF6804D4C4292693A80');
INSERT INTO `order` VALUES ('538EF9A8D51611EEB516002B67D6086B', '2024-02-27 10:17:16', 2755.00, 1, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('54E1714DA2F911EE99A4002B67D6086B', '2023-12-25 15:40:54', 67.60, 1, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('56d488e1a23a11ee99a4002b67d6086b', '2023-12-24 16:53:49', 0.00, 4, NULL, '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('57102D0536E211F0B5BD002B67D6086B', '2025-05-22 15:56:48', 3295.40, 2, '123123', '06B1374AAF244FF6804D4C4292693A80');
INSERT INTO `order` VALUES ('573AEAF636FE11F09334002B67D6086B', '2025-05-22 19:17:26', 67.60, 4, '哈尔滨市  香坊区   赣水路    XXX 收', '06B1374AAF244FF6804D4C4292693A80');
INSERT INTO `order` VALUES ('5A5F46B9D51111EEB516002B67D6086B', '2024-02-27 09:41:40', 1907.70, 1, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('5c73d7df9af84d788acbfbd2c2b97d6c', '2025-12-21 23:28:39', 22.00, 3, '哈尔滨市  香坊区   赣水路    XXX 收', '3165a7333dbe45c78165b3f4db05c63f');
INSERT INTO `order` VALUES ('602a5495454c4602bd40c9bbea28cf8d', '2025-12-22 00:08:34', 33.80, 3, '肇庆市  三卡拉区   三卡拉路    KLF 收', '3165a7333dbe45c78165b3f4db05c63f');
INSERT INTO `order` VALUES ('6CBDA22456CA99D5B1CFB50AFFE39F00', '2022-06-26 11:07:17', 123.40, 4, '哈尔滨市  香坊区   赣水路    XXX 收', '06B1374AAF244FF6804D4C4292693A80');
INSERT INTO `order` VALUES ('77cbe0ff545849c3b89ccb79836a83f6', '2025-12-20 01:12:26', 233.00, 4, '肇庆市  三卡拉区   三卡拉路    KLF 收', '3165a7333dbe45c78165b3f4db05c63f');
INSERT INTO `order` VALUES ('7EAC1772F889D2F2265D8C6D5E28C9FC', '2022-06-26 12:36:49', 33.80, 5, '哈尔滨市  香坊区   赣水路    XXX 收', '06B1374AAF244FF6804D4C4292693A80');
INSERT INTO `order` VALUES ('8E13F415F1F79AD16B5083CF8D99A43A', '2022-06-26 12:33:54', 5825.00, 2, '哈尔滨市  香坊区   赣水路    XXX 收', '06B1374AAF244FF6804D4C4292693A80');
INSERT INTO `order` VALUES ('8F01AC6B9F38D0F675145D6969208D47', '2022-06-26 12:39:34', 12340.00, 4, '哈尔滨市  香坊区   赣水路    XXX 收', '06B1374AAF244FF6804D4C4292693A80');
INSERT INTO `order` VALUES ('8f1e6c2953ad4ee183eadc7af8542992', '2025-12-19 12:48:43', 55.10, 1, '肇庆市  三卡拉区   三卡拉路    KLF 收', '7733A909DC8C11F0B9D3B44506D77805');
INSERT INTO `order` VALUES ('98ccc245b69d46ef904178e00fe9f7d4', '2025-12-21 23:39:14', 55.10, 5, '肇庆市  三卡拉区   三卡拉路    KLF 收', '3165a7333dbe45c78165b3f4db05c63f');
INSERT INTO `order` VALUES ('9acad3b209594fd0aa46ebe1bb66d65c', '2025-12-21 23:41:36', 68.30, 5, '肇庆市  三卡拉区   三卡拉路    KLF 收', '3165a7333dbe45c78165b3f4db05c63f');
INSERT INTO `order` VALUES ('9b2d74fb780d43bca2ae9bf2d9b1a0c2', '2025-12-20 04:27:38', 68.30, 5, '肇庆市  三卡拉区   三卡拉路    KLF 收', '3165a7333dbe45c78165b3f4db05c63f');
INSERT INTO `order` VALUES ('A29F1DD3A23C11EE99A4002B67D6086B', '2023-12-24 17:10:15', 1111111.00, 2, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('A4B98FE9B76F11EF9EF4002B67D6086B', '2024-12-11 11:23:31', 334.90, 1, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('a65c0597a23a11ee99a4002b67d6086b', '2023-12-24 16:56:03', 1234567.00, 2, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('a87c4ae039514db191d0e32cea566153', '2025-12-20 01:33:42', 88.80, 3, '肇庆市  三卡拉区   三卡拉路    KLF 收', '3165a7333dbe45c78165b3f4db05c63f');
INSERT INTO `order` VALUES ('b2971e5ca23b11ee99a4002b67d6086b', '2023-12-24 17:03:33', 1111.00, 1, '哈尔滨市收123', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('B384EB3BD5E211EEA3AC002B67D6086B', '2024-02-28 10:40:14', 2035000.00, 1, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('bd8d6bb4aa3846adbc40ca3fde0cf3f9', '2025-12-20 02:14:13', 33.80, 4, '肇庆市  三卡拉区   三卡拉路    KLF 收', '3165a7333dbe45c78165b3f4db05c63f');
INSERT INTO `order` VALUES ('d039394aa23a11ee99a4002b67d6086b', '2023-12-24 16:57:13', 11222.00, 1, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('d24d5c65e42b4d94abafea6235ebff99', '2025-12-19 11:22:33', 333.00, 1, '肇庆市  三卡拉区   三卡拉路    KLF 收', '1bb7ed4c7fec470cbb24ba49aed9f94a');
INSERT INTO `order` VALUES ('d4e12d68afa24cd78d455395cb0097f6', '2025-12-20 02:14:43', 75.20, 4, '肇庆市  三卡拉区   三卡拉路    KLF 收', '3165a7333dbe45c78165b3f4db05c63f');
INSERT INTO `order` VALUES ('DB511FAFD5DF11EEA3AC002B67D6086B', '2024-02-28 10:19:52', 95730.90, 1, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('E1EAB96FD51711EEB516002B67D6086B', '2024-02-27 10:28:24', 8140.00, 1, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('E43969F4A23C11EE99A4002B67D6086B', '2023-12-24 17:12:05', 2222.00, 1, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('E4C90CD3A2F611EE99A4002B67D6086B', '2023-12-25 15:23:27', 3333333.00, 2, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('e7eb9f51336e4f76b0596e6c172021f4', '2025-12-23 06:34:07', 134.60, 4, '肇庆市  三卡拉区   三卡拉路    KLF 收', '3165a7333dbe45c78165b3f4db05c63f');
INSERT INTO `order` VALUES ('eaf3b5447626462cbe907220158b8baf', '2025-12-21 23:28:08', 75.20, 2, '肇庆市  三卡拉区   三卡拉路    KLF 收', '3165a7333dbe45c78165b3f4db05c63f');
INSERT INTO `order` VALUES ('ef002132f24e4b46b3f2ea2120a08162', '2025-12-19 10:40:58', 333.00, 1, '哈尔滨市  香坊区   赣水路    XXX 收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('f17b05ce299f49e89352e028d343300a', '2025-12-21 23:38:46', 22.00, 5, '肇庆市  三卡拉区   三卡拉路    KLF 收', '3165a7333dbe45c78165b3f4db05c63f');
INSERT INTO `order` VALUES ('F3A0BBE2A2F511EE99A4002B67D6086B', '2023-12-25 15:16:42', 55.10, 2, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('f47f0244604c462cb07170f12c369a6a', '2025-12-19 12:53:12', 75.20, 1, '肇庆市  三卡拉区   三卡拉路    KLF 收', '7733A909DC8C11F0B9D3B44506D77805');
INSERT INTO `order` VALUES ('f535b2e5bf2f49b99acdc47aeb11e0a1', '2025-12-20 01:04:51', 81.40, 5, '肇庆市  三卡拉区   三卡拉路    KLF 收', '3165a7333dbe45c78165b3f4db05c63f');
INSERT INTO `order` VALUES ('f63f6c5a944c44968c7728f5308ce421', '2025-12-19 10:54:13', 666.00, 1, '', '5cdebd0f86c211ee8cb0002b67d6086b');
INSERT INTO `order` VALUES ('F699A1F5A2F811EE99A4002B67D6086B', '2023-12-25 15:38:16', 55.10, 2, '哈尔滨市收', '5cdebd0f86c211ee8cb0002b67d6086b');

-- ----------------------------
-- Table structure for orderitem
-- ----------------------------
DROP TABLE IF EXISTS `orderitem`;
CREATE TABLE `orderitem`  (
  `orderItemId` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `quantity` int NULL DEFAULT NULL,
  `subtotal` decimal(10, 2) NULL DEFAULT NULL,
  `bid` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `bname` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `currPrice` decimal(8, 2) NULL DEFAULT NULL,
  `image_b` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `oid` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`orderItemId`) USING BTREE,
  INDEX `FK_t_orderitem_t_order`(`oid` ASC) USING BTREE,
  CONSTRAINT `FK_t_orderitem_t_order` FOREIGN KEY (`oid`) REFERENCES `order` (`oid`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of orderitem
-- ----------------------------
INSERT INTO `orderitem` VALUES ('07254b78a9ee4831bd02cdc16792b93b', 1, 67.60, '0EE8A0AE69154287A378FB110FF2C780', 'Java核心技术：卷Ⅰ基础知识（原书第8版）', 67.60, 'book_img/20285763-1_b.jpg', '2e8f60c370044feca395e10b32f092f0');
INSERT INTO `orderitem` VALUES ('08e93100d5e211eea3ac002b67d6086b', 1, 33.80, '1A15DC5E8A014A58862ED741D579B530', 'Java深入解析——透析Java本质的36个话题', 33.80, 'book_img/23363997-1_b.jpg', '08E8E1C2D5E211EEA3AC002B67D6086B');
INSERT INTO `orderitem` VALUES ('0f5a4cf146ea41f19a4b0c18b00cfb62', 1, 81.40, '113D0D1BB9174DD19A7DE7E2B37F677F', 'Java7入门经典（跟编程导师Ivor Horton学Java 预计到货日期9月初）', 81.40, 'book_img/22813026-1_b.jpg', '308b444c71db4004ac4439b4dcce1d8b');
INSERT INTO `orderitem` VALUES ('13f42e60c8f74030b687b46cb173978f', 1, 68.90, '4C3331CAD5A5453787A94B8D7CCEAA29', 'Java Web整合开发王者归来（JSP+Servlet+Struts+Hibernate+Spring）（配光盘', 68.90, 'book_img/20756351-1_b_1.jpg', 'e7eb9f51336e4f76b0596e6c172021f4');
INSERT INTO `orderitem` VALUES ('16B0A6B610C7833912F52A5C43E44725', 50, 2410.00, '7917F5B19A0948FD9551932909328E4E', 'Java项目开发案例全程实录（第2版）（配光盘）（软件项目开发全程实录丛书）', 48.20, 'book_img/20991549-1_b.jpg', '8E13F415F1F79AD16B5083CF8D99A43A');
INSERT INTO `orderitem` VALUES ('193922daa23d11ee99a4002b67d6086b', 1, 88.80, '210A3DCA429049C78B623C3986BEB136', 'JavaScript经典教程套装：JavaScript高级程序设计(第3版)+JavaScript DOM编程艺术(第2版)(套装共2册)(超值附赠《码农》光盘1张)', 88.80, 'book_img/23224089-1_b.jpg', '1938A151A23D11EE99A4002B67D6086B');
INSERT INTO `orderitem` VALUES ('1939b073a23d11ee99a4002b67d6086b', 1, 55.10, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', '1938A151A23D11EE99A4002B67D6086B');
INSERT INTO `orderitem` VALUES ('1a382003a23c11ee99a4002b67d6086b', 1, 68.30, '13EBF9B1FDE346A683A1C45BD6773ECB', 'Java开发实战1200例（第Ⅱ卷）（史上最全的“编程实例”类图书，代码分析、实例速查、练习巩固的绝好帮手）', 68.30, 'book_img/21110930-1_b.jpg', '1A37C14DA23C11EE99A4002B67D6086B');
INSERT INTO `orderitem` VALUES ('1a384f17a23c11ee99a4002b67d6086b', 1, 81.40, '113D0D1BB9174DD19A7DE7E2B37F677F', 'Java7入门经典（跟编程导师Ivor Horton学Java 预计到货日期9月初）', 81.40, 'book_img/22813026-1_b.jpg', '1A37C14DA23C11EE99A4002B67D6086B');
INSERT INTO `orderitem` VALUES ('21f9b783d51811eeb516002b67d6086b', 100, 6760.00, '0EE8A0AE69154287A378FB110FF2C780', 'Java核心技术：卷Ⅰ基础知识（原书第8版）', 67.60, 'book_img/20285763-1_b.jpg', '21F89E5DD51811EEB516002B67D6086B');
INSERT INTO `orderitem` VALUES ('27799cc3a23e11ee99a4002b67d6086b', 1, 55.10, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', '2777C6EBA23E11EE99A4002B67D6086B');
INSERT INTO `orderitem` VALUES ('2779dc70a23e11ee99a4002b67d6086b', 1, 68.30, '0BE0707984014E66BD9F34F534FCE0F7', 'OSGi实战【OSGi规范制定者亲自撰写 汇集Apache项目技术实战经验】', 68.30, 'book_img/22938396-1_b.jpg', '2777C6EBA23E11EE99A4002B67D6086B');
INSERT INTO `orderitem` VALUES ('284a100c2bdb42aebf54a65397a895e0', 1, 33.80, '1A15DC5E8A014A58862ED741D579B530', 'Java深入解析——透析Java本质的36个话题', 33.80, 'book_img/23363997-1_b.jpg', 'bd8d6bb4aa3846adbc40ca3fde0cf3f9');
INSERT INTO `orderitem` VALUES ('2c42cc3ad856404d8c387448898edf76', 1, 55.10, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', '98ccc245b69d46ef904178e00fe9f7d4');
INSERT INTO `orderitem` VALUES ('2d6ce795cbf048718dd15c11f8c8f017', 1, 233.00, 'aea5c8bd84cd4c559f288ca965c7001e', 'qqq', 233.00, 'book_img/696673-1_b.jpg', '77cbe0ff545849c3b89ccb79836a83f6');
INSERT INTO `orderitem` VALUES ('32788f0f84ca1588514029fbf4f65855', 3, 202.80, '0EE8A0AE69154287A378FB110FF2C780', 'Java核心技术：卷Ⅰ基础知识（原书第8版）', 67.60, 'book_img/20285763-1_b.jpg', '474CDA8C36FE11F09334002B67D6086B');
INSERT INTO `orderitem` VALUES ('379d9dc5875a9e9972b4d860a13a9e02', 2, 110.20, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', '474CDA8C36FE11F09334002B67D6086B');
INSERT INTO `orderitem` VALUES ('3cd8fe6876db487786e05f146d96cc7a', 1, 75.20, '1286B13F0EA54E4CB75434762121486A', 'Java核心技术 卷I：基础知识(第9版·英文版)(上、下册)', 75.20, 'book_img/23280479-1_b.jpg', 'd4e12d68afa24cd78d455395cb0097f6');
INSERT INTO `orderitem` VALUES ('5289244842b04e3f988665e005e0e73a', 1, NULL, '0EE8A0AE69154287A378FB110FF2C780', NULL, NULL, NULL, '471481f160ff44649c1c5244c75fbb0a');
INSERT INTO `orderitem` VALUES ('53904172d51611eeb516002b67d6086b', 50, 2755.00, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', '538EF9A8D51611EEB516002B67D6086B');
INSERT INTO `orderitem` VALUES ('53E75FC3AF318014B806052BEC96DEAE', 1, 33.80, '6398A7BA400D40258796BCBB2B256068', 'JavaScript设计模式', 33.80, 'book_img/23266635-1_b.jpg', '7EAC1772F889D2F2265D8C6D5E28C9FC');
INSERT INTO `orderitem` VALUES ('54e1a5aca2f911ee99a4002b67d6086b', 1, 67.60, '0EE8A0AE69154287A378FB110FF2C780', 'Java核心技术：卷Ⅰ基础知识（原书第8版）', 67.60, 'book_img/20285763-1_b.jpg', '54E1714DA2F911EE99A4002B67D6086B');
INSERT INTO `orderitem` VALUES ('55F0A13F02194970C16ADD8958F5B295', 1, 68.30, '0BE0707984014E66BD9F34F534FCE0F7', 'OSGi实战【OSGi规范制定者亲自撰写 汇集Apache项目技术实战经验】', 68.30, 'book_img/22938396-1_b.jpg', '6CBDA22456CA99D5B1CFB50AFFE39F00');
INSERT INTO `orderitem` VALUES ('56d59b09a23a11ee99a4002b67d6086b', 2, 162.80, '113D0D1BB9174DD19A7DE7E2B37F677F', 'Java7入门经典（跟编程导师Ivor Horton学Java 预计到货日期9月初）', 81.40, 'book_img/22813026-1_b.jpg', '56d488e1a23a11ee99a4002b67d6086b');
INSERT INTO `orderitem` VALUES ('56d5ef58a23a11ee99a4002b67d6086b', 2, 136.60, '0BE0707984014E66BD9F34F534FCE0F7', 'OSGi实战【OSGi规范制定者亲自撰写 汇集Apache项目技术实战经验】', 68.30, 'book_img/22938396-1_b.jpg', '56d488e1a23a11ee99a4002b67d6086b');
INSERT INTO `orderitem` VALUES ('56d62a78a23a11ee99a4002b67d6086b', 1, 68.30, '13EBF9B1FDE346A683A1C45BD6773ECB', 'Java开发实战1200例（第Ⅱ卷）（史上最全的“编程实例”类图书，代码分析、实例速查、练习巩固的绝好帮手）', 68.30, 'book_img/21110930-1_b.jpg', '56d488e1a23a11ee99a4002b67d6086b');
INSERT INTO `orderitem` VALUES ('578cf2b620404032a4eb1de6304961a4', 1, 22.00, '5a4438a94b514157b0aefdb45f0d6cb7', '阿萨姆奶茶', 22.00, 'book_img/696673-1_b.jpg', 'f17b05ce299f49e89352e028d343300a');
INSERT INTO `orderitem` VALUES ('5a603903d51111eeb516002b67d6086b', 1, 67.60, '0EE8A0AE69154287A378FB110FF2C780', 'Java核心技术：卷Ⅰ基础知识（原书第8版）', 67.60, 'book_img/20285763-1_b.jpg', '5A5F46B9D51111EEB516002B67D6086B');
INSERT INTO `orderitem` VALUES ('5a60cd37d51111eeb516002b67d6086b', 10, 683.00, '0BE0707984014E66BD9F34F534FCE0F7', 'OSGi实战【OSGi规范制定者亲自撰写 汇集Apache项目技术实战经验】', 68.30, 'book_img/22938396-1_b.jpg', '5A5F46B9D51111EEB516002B67D6086B');
INSERT INTO `orderitem` VALUES ('5a610e24d51111eeb516002b67d6086b', 21, 1157.10, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', '5A5F46B9D51111EEB516002B67D6086B');
INSERT INTO `orderitem` VALUES ('5f212fcda04b47beb01df9598d6f555e', 1, 22.00, '5a4438a94b514157b0aefdb45f0d6cb7', '阿萨姆奶茶', 22.00, 'book_img/696673-1_b.jpg', '5c73d7df9af84d788acbfbd2c2b97d6c');
INSERT INTO `orderitem` VALUES ('5f674e93986246ea94a0be85d079bc3c', 1, 33.80, '1A15DC5E8A014A58862ED741D579B530', 'Java深入解析——透析Java本质的36个话题', 33.80, 'book_img/23363997-1_b.jpg', '2785f803cced4fe580bcb760481f3b4e');
INSERT INTO `orderitem` VALUES ('6674D5C14374B7C741A1FA0799A21E28', 100, 6830.00, '0BE0707984014E66BD9F34F534FCE0F7', 'OSGi实战【OSGi规范制定者亲自撰写 汇集Apache项目技术实战经验】', 68.30, 'book_img/22938396-1_b.jpg', '8F01AC6B9F38D0F675145D6969208D47');
INSERT INTO `orderitem` VALUES ('780e6aecdb039e6a6fa01787520a9e0e', 1, 67.60, '0EE8A0AE69154287A378FB110FF2C780', 'Java核心技术：卷Ⅰ基础知识（原书第8版）', 67.60, 'book_img/20285763-1_b.jpg', '573AEAF636FE11F09334002B67D6086B');
INSERT INTO `orderitem` VALUES ('7db5928b347741f39a70ddcaa0db713b', 1, 333.00, 'aea5c8bd84cd4c559f288ca965c7001e', 'qqq', 333.00, 'book_img/696673-1_b.jpg', 'd24d5c65e42b4d94abafea6235ebff99');
INSERT INTO `orderitem` VALUES ('858eb5efb378fc21278b1a49406ed96f', 1, 88.80, '210A3DCA429049C78B623C3986BEB136', 'JavaScript经典教程套装：JavaScript高级程序设计(第3版)+JavaScript DOM编程艺术(第2版)(套装共2册)(超值附赠《码农》光盘1张)', 88.80, 'book_img/23224089-1_b.jpg', '57102D0536E211F0B5BD002B67D6086B');
INSERT INTO `orderitem` VALUES ('895b29d8bb134e32b7734caa10c6d609', 1, 65.70, 'A46A0F48A4F649AE9008B38EA48FAEBA', 'Java编程全能词典(含DVD光盘2张)', 65.70, 'book_img/20813806-1_b.jpg', 'e7eb9f51336e4f76b0596e6c172021f4');
INSERT INTO `orderitem` VALUES ('a2a0e30da23c11ee99a4002b67d6086b', 1, 67.60, '0EE8A0AE69154287A378FB110FF2C780', 'Java核心技术：卷Ⅰ基础知识（原书第8版）', 67.60, 'book_img/20285763-1_b.jpg', 'A29F1DD3A23C11EE99A4002B67D6086B');
INSERT INTO `orderitem` VALUES ('a2a105fda23c11ee99a4002b67d6086b', 1, 55.10, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', 'A29F1DD3A23C11EE99A4002B67D6086B');
INSERT INTO `orderitem` VALUES ('a4bb70deb76f11ef9ef4002b67d6086b', 1, 68.30, '13EBF9B1FDE346A683A1C45BD6773ECB', 'Java开发实战1200例（第Ⅱ卷）（史上最全的“编程实例”类图书，代码分析、实例速查、练习巩固的绝好帮手）', 68.30, 'book_img/21110930-1_b.jpg', 'A4B98FE9B76F11EF9EF4002B67D6086B');
INSERT INTO `orderitem` VALUES ('a4bbc844b76f11ef9ef4002b67d6086b', 1, 67.60, '0EE8A0AE69154287A378FB110FF2C780', 'Java核心技术：卷Ⅰ基础知识（原书第8版）', 67.60, 'book_img/20285763-1_b.jpg', 'A4B98FE9B76F11EF9EF4002B67D6086B');
INSERT INTO `orderitem` VALUES ('a4bbfd99b76f11ef9ef4002b67d6086b', 1, 88.80, '210A3DCA429049C78B623C3986BEB136', 'JavaScript经典教程套装：JavaScript高级程序设计(第3版)+JavaScript DOM编程艺术(第2版)(套装共2册)(超值附赠《码农》光盘1张)', 88.80, 'book_img/23224089-1_b.jpg', 'A4B98FE9B76F11EF9EF4002B67D6086B');
INSERT INTO `orderitem` VALUES ('a4bc37dbb76f11ef9ef4002b67d6086b', 2, 110.20, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', 'A4B98FE9B76F11EF9EF4002B67D6086B');
INSERT INTO `orderitem` VALUES ('a65dd363a23a11ee99a4002b67d6086b', 6, 330.60, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', 'a65c0597a23a11ee99a4002b67d6086b');
INSERT INTO `orderitem` VALUES ('a65e02c0a23a11ee99a4002b67d6086b', 1, 81.40, '113D0D1BB9174DD19A7DE7E2B37F677F', 'Java7入门经典（跟编程导师Ivor Horton学Java 预计到货日期9月初）', 81.40, 'book_img/22813026-1_b.jpg', 'a65c0597a23a11ee99a4002b67d6086b');
INSERT INTO `orderitem` VALUES ('b28902142bfb4b5f9eb6ad00a168c629', 1, 68.30, '0BE0707984014E66BD9F34F534FCE0F7', 'OSGi实战【OSGi规范制定者亲自撰写 汇集Apache项目技术实战经验】', 68.30, 'book_img/22938396-1_b.jpg', '9acad3b209594fd0aa46ebe1bb66d65c');
INSERT INTO `orderitem` VALUES ('b2975cf6a23b11ee99a4002b67d6086b', 1, 55.10, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', 'b2971e5ca23b11ee99a4002b67d6086b');
INSERT INTO `orderitem` VALUES ('b297855da23b11ee99a4002b67d6086b', 1, 67.60, '0EE8A0AE69154287A378FB110FF2C780', 'Java核心技术：卷Ⅰ基础知识（原书第8版）', 67.60, 'book_img/20285763-1_b.jpg', 'b2971e5ca23b11ee99a4002b67d6086b');
INSERT INTO `orderitem` VALUES ('b297b871a23b11ee99a4002b67d6086b', 1, 81.40, '113D0D1BB9174DD19A7DE7E2B37F677F', 'Java7入门经典（跟编程导师Ivor Horton学Java 预计到货日期9月初）', 81.40, 'book_img/22813026-1_b.jpg', 'b2971e5ca23b11ee99a4002b67d6086b');
INSERT INTO `orderitem` VALUES ('b385b243d5e211eea3ac002b67d6086b', 25000, 2035000.00, '113D0D1BB9174DD19A7DE7E2B37F677F', 'Java7入门经典（跟编程导师Ivor Horton学Java 预计到货日期9月初）', 81.40, 'book_img/22813026-1_b.jpg', 'B384EB3BD5E211EEA3AC002B67D6086B');
INSERT INTO `orderitem` VALUES ('b5c0fd3f47fe4fc78601680ff60ccb13', 1, 88.80, '210A3DCA429049C78B623C3986BEB136', 'JavaScript经典教程套装：JavaScript高级程序设计(第3版)+JavaScript DOM编程艺术(第2版)(套装共2册)(超值附赠《码农》光盘1张)', 88.80, 'book_img/23224089-1_b.jpg', 'a87c4ae039514db191d0e32cea566153');
INSERT INTO `orderitem` VALUES ('b7b2d60ee999e17ed470e38114451f67', 9, 608.40, '0EE8A0AE69154287A378FB110FF2C780', 'Java核心技术：卷Ⅰ基础知识（原书第8版）', 67.60, 'book_img/20285763-1_b.jpg', '57102D0536E211F0B5BD002B67D6086B');
INSERT INTO `orderitem` VALUES ('bf4adc44a25149629646a7c35866fc18', 1, 81.40, '113D0D1BB9174DD19A7DE7E2B37F677F', 'Java7入门经典（跟编程导师Ivor Horton学Java 预计到货日期9月初）', 81.40, 'book_img/22813026-1_b.jpg', 'f535b2e5bf2f49b99acdc47aeb11e0a1');
INSERT INTO `orderitem` VALUES ('C25F57EF9743BC1B8001EACEBE3A1B6E', 1, 55.10, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', '6CBDA22456CA99D5B1CFB50AFFE39F00');
INSERT INTO `orderitem` VALUES ('c3dcb41f443f02857a743582252a01ab', 20, 1642.00, '3DD187217BF44A99B86DD18A4DC628BA', 'Java核心技术 卷1 基础知识（原书第9版）', 82.10, 'book_img/23362142-1_b.jpg', '57102D0536E211F0B5BD002B67D6086B');
INSERT INTO `orderitem` VALUES ('c5c1687a050842208275572cb15ce6ef', 1, 68.30, '0BE0707984014E66BD9F34F534FCE0F7', 'OSGi实战【OSGi规范制定者亲自撰写 汇集Apache项目技术实战经验】', 68.30, 'book_img/22938396-1_b.jpg', '9b2d74fb780d43bca2ae9bf2d9b1a0c2');
INSERT INTO `orderitem` VALUES ('C7F4F970C9ADD75112E6877C7B1BB01C', 50, 3415.00, '676B56A612AF4E968CF0F6FFE289269D', 'JavaScript和jQuery实战手册（原书第2版）', 68.30, 'book_img/23201813-1_b.jpg', '8E13F415F1F79AD16B5083CF8D99A43A');
INSERT INTO `orderitem` VALUES ('cc97a3f6766140bfb1b0132696636d1a', 1, 75.20, '1286B13F0EA54E4CB75434762121486A', 'Java核心技术 卷I：基础知识(第9版·英文版)(上、下册)', 75.20, 'book_img/23280479-1_b.jpg', 'eaf3b5447626462cbe907220158b8baf');
INSERT INTO `orderitem` VALUES ('d03b23f1a23a11ee99a4002b67d6086b', 1, 88.80, '210A3DCA429049C78B623C3986BEB136', 'JavaScript经典教程套装：JavaScript高级程序设计(第3版)+JavaScript DOM编程艺术(第2版)(套装共2册)(超值附赠《码农》光盘1张)', 88.80, 'book_img/23224089-1_b.jpg', 'd039394aa23a11ee99a4002b67d6086b');
INSERT INTO `orderitem` VALUES ('db52ab18d5df11eea3ac002b67d6086b', 51, 3483.30, '0BE0707984014E66BD9F34F534FCE0F7', 'OSGi实战【OSGi规范制定者亲自撰写 汇集Apache项目技术实战经验】', 68.30, 'book_img/22938396-1_b.jpg', 'DB511FAFD5DF11EEA3AC002B67D6086B');
INSERT INTO `orderitem` VALUES ('db53c7d5d5df11eea3ac002b67d6086b', 51, 3447.60, '0EE8A0AE69154287A378FB110FF2C780', 'Java核心技术：卷Ⅰ基础知识（原书第8版）', 67.60, 'book_img/20285763-1_b.jpg', 'DB511FAFD5DF11EEA3AC002B67D6086B');
INSERT INTO `orderitem` VALUES ('db543a5fd5df11eea3ac002b67d6086b', 1000, 88800.00, '210A3DCA429049C78B623C3986BEB136', 'JavaScript经典教程套装：JavaScript高级程序设计(第3版)+JavaScript DOM编程艺术(第2版)(套装共2册)(超值附赠《码农》光盘1张)', 88.80, 'book_img/23224089-1_b.jpg', 'DB511FAFD5DF11EEA3AC002B67D6086B');
INSERT INTO `orderitem` VALUES ('dbde4abefb8d5fcc063303f9c3ff7021', 14, 956.20, '0BE0707984014E66BD9F34F534FCE0F7', 'OSGi实战【OSGi规范制定者亲自撰写 汇集Apache项目技术实战经验】', 68.30, 'book_img/22938396-1_b.jpg', '57102D0536E211F0B5BD002B67D6086B');
INSERT INTO `orderitem` VALUES ('dc73475049224a0a9b84385603355312', 1, 55.10, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', '8f1e6c2953ad4ee183eadc7af8542992');
INSERT INTO `orderitem` VALUES ('e1eb9a3cd51711eeb516002b67d6086b', 100, 8140.00, '113D0D1BB9174DD19A7DE7E2B37F677F', 'Java7入门经典（跟编程导师Ivor Horton学Java 预计到货日期9月初）', 81.40, 'book_img/22813026-1_b.jpg', 'E1EAB96FD51711EEB516002B67D6086B');
INSERT INTO `orderitem` VALUES ('e3bba5facd2840c0924cf1659c039d2d', 2, 666.00, 'aea5c8bd84cd4c559f288ca965c7001e', 'qqq', 333.00, 'book_img/696673-1_b.jpg', 'f63f6c5a944c44968c7728f5308ce421');
INSERT INTO `orderitem` VALUES ('e439a210a23c11ee99a4002b67d6086b', 1, 67.60, '0EE8A0AE69154287A378FB110FF2C780', 'Java核心技术：卷Ⅰ基础知识（原书第8版）', 67.60, 'book_img/20285763-1_b.jpg', 'E43969F4A23C11EE99A4002B67D6086B');
INSERT INTO `orderitem` VALUES ('e439d19ea23c11ee99a4002b67d6086b', 1, 55.10, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', 'E43969F4A23C11EE99A4002B67D6086B');
INSERT INTO `orderitem` VALUES ('e4c94270a2f611ee99a4002b67d6086b', 2, 110.20, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', 'E4C90CD3A2F611EE99A4002B67D6086B');
INSERT INTO `orderitem` VALUES ('ee75be73137aa0ba1df281dbfe92d4c3', 4, 325.60, '113D0D1BB9174DD19A7DE7E2B37F677F', 'Java7入门经典（跟编程导师Ivor Horton学Java 预计到货日期9月初）', 81.40, 'book_img/22813026-1_b.jpg', '474CDA8C36FE11F09334002B67D6086B');
INSERT INTO `orderitem` VALUES ('f322f8d5bd624294af2274fb054e7fde', 1, 75.20, '1286B13F0EA54E4CB75434762121486A', 'Java核心技术 卷I：基础知识(第9版·英文版)(上、下册)', 75.20, 'book_img/23280479-1_b.jpg', 'f47f0244604c462cb07170f12c369a6a');
INSERT INTO `orderitem` VALUES ('f3a16d28a2f511ee99a4002b67d6086b', 1, 55.10, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', 'F3A0BBE2A2F511EE99A4002B67D6086B');
INSERT INTO `orderitem` VALUES ('f699e2f7a2f811ee99a4002b67d6086b', 1, 55.10, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', 'F699A1F5A2F811EE99A4002B67D6086B');
INSERT INTO `orderitem` VALUES ('F6FD1FA7F3F5097945DC1CE675C48204', 100, 5510.00, '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 55.10, 'book_img/23268958-1_b.jpg', '8F01AC6B9F38D0F675145D6969208D47');
INSERT INTO `orderitem` VALUES ('faee701232304af1915a43a9ef2ec9d7', 1, 333.00, 'aea5c8bd84cd4c559f288ca965c7001e', 'qqq', 333.00, 'book_img/696673-1_b.jpg', 'ef002132f24e4b46b3f2ea2120a08162');
INSERT INTO `orderitem` VALUES ('fafec0dfd01e4a1fac7688722ceda1cd', 1, 33.80, 'B7A7DA7A94E54054841EED1F70C3027C', '锋利的jQuery(第2版)(畅销书升级版，增加jQuery Mobile和性能优化)', 33.80, 'book_img/22786088-1_b.jpg', '602a5495454c4602bd40c9bbea28cf8d');

-- ----------------------------
-- Table structure for stock
-- ----------------------------
DROP TABLE IF EXISTS `stock`;
CREATE TABLE `stock`  (
  `sid` varchar(36) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `bid` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `bname` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `quantity` int NOT NULL,
  `minQuantity` int NOT NULL DEFAULT 10,
  `status` tinyint NOT NULL,
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`sid`) USING BTREE,
  UNIQUE INDEX `idx_bid`(`bid` ASC) USING BTREE,
  CONSTRAINT `fk_stock_book` FOREIGN KEY (`bid`) REFERENCES `book` (`bid`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of stock
-- ----------------------------
INSERT INTO `stock` VALUES ('4c6c6973068b4c568d1bba647a260ffc', '5a4438a94b514157b0aefdb45f0d6cb7', NULL, 30, 10, 1, '2025-12-23 06:42:33');
INSERT INTO `stock` VALUES ('d1dac815-dcd9-11f0-b9d3-b44506d77805', '000A18FDB38F470DBE9CD0972BADB23F', 'Java Web整合开发实战--基于Struts 2+Hibernate+Spring（99个应用实例，4个项目开发案例，15.5小时配套教学视频，超值DVD光盘含大量开发资源。一本书搞定SSH框架整合开发！）', 96, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1dba569-dcd9-11f0-b9d3-b44506d77805', '0BE0707984014E66BD9F34F534FCE0F7', 'OSGi实战【OSGi规范制定者亲自撰写 汇集Apache项目技术实战经验】', 167, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1dcab88-dcd9-11f0-b9d3-b44506d77805', '0EE8A0AE69154287A378FB110FF2C780', 'Java核心技术：卷Ⅰ基础知识（原书第8版）', 157, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1dde8c0-dcd9-11f0-b9d3-b44506d77805', '113D0D1BB9174DD19A7DE7E2B37F677F', 'Java7入门经典（跟编程导师Ivor Horton学Java 预计到货日期9月初）', 81, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1dea118-dcd9-11f0-b9d3-b44506d77805', '1286B13F0EA54E4CB75434762121486A', 'Java核心技术 卷I：基础知识(第9版·英文版)(上、下册)', 116, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1df5fa4-dcd9-11f0-b9d3-b44506d77805', '13EBF9B1FDE346A683A1C45BD6773ECB', 'Java开发实战1200例（第Ⅱ卷）（史上最全的“编程实例”类图书，代码分析、实例速查、练习巩固的绝好帮手）', 137, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1e01d86-dcd9-11f0-b9d3-b44506d77805', '1A15DC5E8A014A58862ED741D579B530', 'Java深入解析——透析Java本质的36个话题', 137, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1e0e4ed-dcd9-11f0-b9d3-b44506d77805', '210A3DCA429049C78B623C3986BEB136', 'JavaScript经典教程套装：JavaScript高级程序设计(第3版)+JavaScript DOM编程艺术(第2版)(套装共2册)(超值附赠《码农》光盘1张)', 74, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1e1a11b-dcd9-11f0-b9d3-b44506d77805', '22234CECF15F4ECB813F0B433DDA5365', 'JavaScript从入门到精通（附光盘1张）（连续8月JavaScript类全国零售排行前2名，13小时视频，400个经典实例、369项面试真题、138项测试史上最全资源库）', 141, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1e25915-dcd9-11f0-b9d3-b44506d77805', '230A00EC22BF4A1DBA87C64800B54C8D', 'Struts2技术内幕：深入解析Struts架构设计与实现原理', 91, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1e30eed-dcd9-11f0-b9d3-b44506d77805', '260F8A3594F741C1B0EB69616F65045B', 'Tomcat与Java Web开发技术详解（第2版）(含光盘1张)', 23, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1e3c6b8-dcd9-11f0-b9d3-b44506d77805', '28A03D28BAD449659A77330BE35FCD65', 'JAVA核心技术卷II：高级特性（原书第8版）', 22, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1e479b2-dcd9-11f0-b9d3-b44506d77805', '2EE1A20A6AF742E387E18619D7E3BB94', 'Java虚拟机并发编程(Java并发编程领域的里程碑之作，资深Java技术专家、并发编程专家、敏捷开发专家和Jolt大奖得主撰写，Amazon五星畅销书)', 33, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1e518ce-dcd9-11f0-b9d3-b44506d77805', '33ACF97A9A374352AE9F5E89BB791262', '基于MVC的JavaScript Web富应用开发', 91, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1e5c07c-dcd9-11f0-b9d3-b44506d77805', '37F75BEAE1FE46F2B14674923F1E7987', '数据结构与算法分析Java语言描述 第2版', 153, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1e6643e-dcd9-11f0-b9d3-b44506d77805', '39F1D0803E8F4592AE1245CACE683214', 'Java程序员修炼之道', 102, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1e71604-dcd9-11f0-b9d3-b44506d77805', '3AE5C8B976B6448A9D3A155C1BDE12BC', '深入理解Java虚拟机:JVM高级特性与最佳实践（超级畅销书，6个月5次印刷，从实践角度解析JVM工作原理，Java程序员必备）', 39, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1e80699-dcd9-11f0-b9d3-b44506d77805', '3DD187217BF44A99B86DD18A4DC628BA', 'Java核心技术 卷1 基础知识（原书第9版）', 72, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1e8af79-dcd9-11f0-b9d3-b44506d77805', '3E1990E19989422E9DA735978CB1E4CE', 'Effective Java中文版(第2版)', 44, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1e96847-dcd9-11f0-b9d3-b44506d77805', '400D94DE5A0742B3A618FC76DF107183', 'JavaScript宝典（第7版）（配光盘）', 185, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1ea167d-dcd9-11f0-b9d3-b44506d77805', '4491EA4832E04B8B94F334B71E871983', 'Java语言程序设计：进阶篇（原书第8版）', 19, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1eac350-dcd9-11f0-b9d3-b44506d77805', '48BBFBFC07074ADE8CC906A45BE5D9A6', 'JavaScript权威指南（第6版）（淘宝前端团队倾情翻译！经典权威的JavaScript犀牛书！第6版特别涵盖了HTML5和ECMAScript5！）（经典巨著，当当独家首发）', 103, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1eb748c-dcd9-11f0-b9d3-b44506d77805', '49D98E7916B94232862F7DCD1B0BAB66', 'HTML5+JavaScript动画基础', 65, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1ec2298-dcd9-11f0-b9d3-b44506d77805', '4A9574F03A6B40C1B2A437237C17DEEC', 'Spring实战(第3版)（In Action系列中最畅销的Spring图书，近十万读者学习Spring的共同选择）', 200, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1ecd1cc-dcd9-11f0-b9d3-b44506d77805', '4BF6D97DD18A4B77B8DED9B057577F8F', 'Java Web从入门到精通（附光盘1张）（连续8月Java类全国零售排行前2名，27小时视频，951个经典实例、369项面试真题、596项测试史上最全资源库）', 31, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1ed7e23-dcd9-11f0-b9d3-b44506d77805', '4c268b08206a4741a639538611fe5ab3', 'a', 120, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1ee34c7-dcd9-11f0-b9d3-b44506d77805', '4C3331CAD5A5453787A94B8D7CCEAA29', 'Java Web整合开发王者归来（JSP+Servlet+Struts+Hibernate+Spring）（配光盘', 115, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1eee108-dcd9-11f0-b9d3-b44506d77805', '4D20D2450B084113A331D909FF4975EB', 'jQuery实战(第2版)(畅销书升级版，掌握Web开发利器必修宝典)', 13, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1ef922d-dcd9-11f0-b9d3-b44506d77805', '4E44405DAFB7413E8A13BBFFBEE73AC7', 'JavaScript经典实例', 94, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1f04435-dcd9-11f0-b9d3-b44506d77805', '504FB999B0444B339907090927FDBE8A', '深入浅出Ext JS(第3版)', 40, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1f0f710-dcd9-11f0-b9d3-b44506d77805', '52077C8423B645A9BADA96A5E0B14422', 'Spring源码深度解析', 99, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1f1b221-dcd9-11f0-b9d3-b44506d77805', '52B0EDFF966E4A058BDA5B18EEC698C4', '亮剑Java Web项目开发案例导航(含DVD光盘1张)', 176, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1f25fc2-dcd9-11f0-b9d3-b44506d77805', '5315DA60D24042889400AD4C93A37501', 'Spring 3.x企业应用开发实战(含CD光盘1张)', 190, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1f30fe2-dcd9-11f0-b9d3-b44506d77805', '56B1B7D8CD8740B098677C7216A673C4', '疯狂 Java 程序员的基本修养（《疯狂Java讲义》最佳拍档，扫清知识死角，夯实基本功）', 29, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1f3c764-dcd9-11f0-b9d3-b44506d77805', '57B6FF1B89C843C38BA39C717FA557D6', '了不起的Node.js: 将JavaScript进行到底（Web开发首选实时 跨多服务器 高并发）', 139, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1f47a27-dcd9-11f0-b9d3-b44506d77805', '5C4A6F0F4A3B4672AD8C5F89BF5D37D2', 'Java从入门到精通（第3版）（附光盘1张）（连续8月Java类全国零售排行前2名，32小时视频，732个经典实例、369项面试真题、616项测试史上最全资源库）', 25, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1f5311e-dcd9-11f0-b9d3-b44506d77805', '5C68141786B84A4CB8929A2415040739', 'JavaScript高级程序设计(第3版)(JavaScript技术名著，国内JavasScript第一书，销量超过8万册)', 79, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1f5eb27-dcd9-11f0-b9d3-b44506d77805', '5EDB981339C342ED8DB17D5A198D50DC', 'Java程序性能优化', 122, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1f69b5c-dcd9-11f0-b9d3-b44506d77805', '6398A7BA400D40258796BCBB2B256068', 'JavaScript设计模式', 172, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1f74cd4-dcd9-11f0-b9d3-b44506d77805', '676B56A612AF4E968CF0F6FFE289269D', 'JavaScript和jQuery实战手册（原书第2版）', 104, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1f81763-dcd9-11f0-b9d3-b44506d77805', '7917F5B19A0948FD9551932909328E4E', 'Java项目开发案例全程实录（第2版）（配光盘）（软件项目开发全程实录丛书）', 186, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1f9ae9f-dcd9-11f0-b9d3-b44506d77805', '7C0C785FFBEC4DEC802FA36E8B0BC87E', '深入分析Java Web技术内幕', 33, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1fb417d-dcd9-11f0-b9d3-b44506d77805', '7CD79C20258F477AB841518D9312E843', 'Java程序员面试宝典（第三版）', 171, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1fd20d4-dcd9-11f0-b9d3-b44506d77805', '7d1bde590ed24642ba76d18d158ff6e0', 'a', 174, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d1feb43d-dcd9-11f0-b9d3-b44506d77805', '7D7FE81293124793BDB2C6FF1F1C943D', '21天学通Java(第6版)（中文版累计销量超30000册）', 156, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d2040da6-dcd9-11f0-b9d3-b44506d77805', '7FD7F50B15F74248AA769798909F8653', 'Java网络编程（第3版）——O’Reilly Java系列', 59, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d2059fbd-dcd9-11f0-b9d3-b44506d77805', '819FF56E4423462394E6F83882F78975', '学通Java Web的24堂课（配光盘）（软件开发羊皮卷）', 197, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d20781ec-dcd9-11f0-b9d3-b44506d77805', '81FADA99309342F4978D5C680B0C6E8C', 'Java入门很简单（配光盘）（入门很简单丛书）（打开Java编程之门 Java技术网推荐）', 37, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d2091a0c-dcd9-11f0-b9d3-b44506d77805', '89A57D099EA14026A5C3D10CFC10C22C', 'Java 2实用教程（第4版）（21世纪高等学校计算机基础实用规划教材）', 155, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d20af1ef-dcd9-11f0-b9d3-b44506d77805', '8A5B4042D5B14D6B87A34DABF327387F', 'Java核心技术 卷II：高级特性(第9版·英文版)(上、下册)', 82, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d20cbdd7-dcd9-11f0-b9d3-b44506d77805', '8b2e3d0a15b947fabde5a3ef571af4d6', 'a', 125, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d20ee469-dcd9-11f0-b9d3-b44506d77805', '8DD0ADF2665B40899E09ED2983DC3F7B', 'jQuery权威指南（被公认的权威的、易学的jQuery实战教程，多次重印，热销中）', 182, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d2101a7d-dcd9-11f0-b9d3-b44506d77805', '8E16D59BA4C34374A68029AE877613C4', '轻量级Java EE企业应用实战（第3版）：Struts 2＋Spring 3＋Hibernate整合开发(含CD光盘1张)', 141, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d2114b51-dcd9-11f0-b9d3-b44506d77805', '8F1520F2CED94C679433B9C109E791CB', 'Java从入门到精通（实例版）（附光盘1张）（连续8月Java类全国零售排行前2名，14小时视频，732个经典实例、369项面试真题、616项测试史上最全资源库）', 150, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d212ac32-dcd9-11f0-b9d3-b44506d77805', '90E423DBE56042838806673DB3E86BD3', '《Spring技术内幕（第2版）》（畅销书全新升级，Spring类图书销量桂冠，从宏观和微观两个角度解析Spring架构设计和实现原理）', 126, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d21368d7-dcd9-11f0-b9d3-b44506d77805', '926B8F31C5D04F61A72F66679A0CCFFD', 'JavaScript编程精解（华章程序员书库）（JavaScript之父高度评价并强力推荐，系统学习JS首选！）', 171, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d2141e15-dcd9-11f0-b9d3-b44506d77805', '95AACC68D64D4D67B1E33E9EAC22B885', 'Head First Java（中文版）（JAVA经典畅销书 生动有趣 轻松学好JAVA）', 84, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d214c774-dcd9-11f0-b9d3-b44506d77805', '97437DAD03FA456AA7D6154614A43B55', 'HTML、CSS、JavaScript网页制作从入门到精通（两万读者的选择，经久不衰的超级畅销书最新升级版！网页制作学习者入门必读经典！）', 88, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d2156eb9-dcd9-11f0-b9d3-b44506d77805', '9923901FBF124623BC707920D8936BC8', 'JavaScript DOM编程艺术(第2版)', 178, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d216166a-dcd9-11f0-b9d3-b44506d77805', '99BF63AC12AD48FCB673F1820888964E', 'Java Web开发实战1200例（第Ⅱ卷）（史上最全的“编程实例”类图书，代码分析、实例速查、练习巩固的绝好帮手）', 45, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d216c1f8-dcd9-11f0-b9d3-b44506d77805', '9D257176A6934CB79427CEC37E69249F', '疯狂Ajax讲义（第3版）--jQuery/Ext JS/Prototype/DWR企业应用前端开发实战(含CD光盘1张)（畅销书升级版，企业应用前端开发实战指南）', 64, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d217706f-dcd9-11f0-b9d3-b44506d77805', '9FBD51A7C02D4F5B9862CD2EBBF5CA04', 'Flash ActionScript 3.0全站互动设计', 174, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d218190a-dcd9-11f0-b9d3-b44506d77805', '9FF423101836438F874035A48498CF45', 'Java编程思想（英文版·第4版）', 96, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d218c2a9-dcd9-11f0-b9d3-b44506d77805', 'A3D464D1D1344ED5983920B472826730', 'Java Web开发详解：XML+DTD+XML Schema+XSLT+Servlet 3 0+JSP 2 2深入剖析与实例应用(含CD光盘1张)', 139, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d2196791-dcd9-11f0-b9d3-b44506d77805', 'A46A0F48A4F649AE9008B38EA48FAEBA', 'Java编程全能词典(含DVD光盘2张)', 17, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d21a0b39-dcd9-11f0-b9d3-b44506d77805', 'A5A6F27DCD174614850B26633A0B4605', 'JavaScript模式', 41, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d21ab696-dcd9-11f0-b9d3-b44506d77805', 'A7220EF174704012830E066FDFAAD4AD', 'Spring 3.0就这么简单（国内原创的Java敏捷开发图书，展现作者Spring原创开源项目ROP开发的全过程，所有项目工程均以Maven组织）', 142, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d21b6b0e-dcd9-11f0-b9d3-b44506d77805', 'A7EFD99367C9434682A790635D3C5FDF', 'Java Web技术整合应用与项目实战（JSP+Servlet+Struts2+Hibernate+Spring3）', 195, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d21c2230-dcd9-11f0-b9d3-b44506d77805', 'A8EF76FD21A645109538614DEA85F3F7', 'Java语言程序设计：基础篇（原书第8版）', 157, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d21cd46c-dcd9-11f0-b9d3-b44506d77805', 'AD6EA79CCB8240AAAF5B292AD7E5DCAA', 'jQuery Mobile权威指南（根据jQuery Mobile最新版本撰写的权威参考书！全面讲解jQuery Mobile的所有功能、特性、使用方法和开发技巧）', 193, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d21d7ea1-dcd9-11f0-b9d3-b44506d77805', 'AE0935F13A214436B8599DE285A86220', 'JavaScript基础教程(第8版)(经典JavaScript入门书 涵盖Ajax和jQuery)', 102, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d21e250d-dcd9-11f0-b9d3-b44506d77805', 'aea5c8bd84cd4c559f288ca965c7001e', 'qqq', 6, 10, 0, '2025-12-19 23:04:09');
INSERT INTO `stock` VALUES ('d21ecbfe-dcd9-11f0-b9d3-b44506d77805', 'AF28ED8F692C4288B32CF411CBDBFC23', '经典Java EE企业应用实战——基于WebLogic/JBoss的JSF+EJB 3+JPA整合开发(含CD光盘1张)', 51, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d21f731d-dcd9-11f0-b9d3-b44506d77805', 'B329A14DDEF8455F82B3FDF25821D2BB', '名师讲坛——Java Web开发实战经典基础篇（JSP、Servlet、Struts、Ajax）（32小时全真课堂培训，视频超级给力！390项实例及分析，北京魔乐科技培训中心Java Web全部精华）', 103, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d22017f5-dcd9-11f0-b9d3-b44506d77805', 'B7A7DA7A94E54054841EED1F70C3027C', '锋利的jQuery(第2版)(畅销书升级版，增加jQuery Mobile和性能优化)', 162, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d220be30-dcd9-11f0-b9d3-b44506d77805', 'BD1CB005E4A04DCA881DA8689E21D4D0', 'jQuery UI开发指南', 110, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d221675d-dcd9-11f0-b9d3-b44506d77805', 'C23E6E8A6DB94E27B6E2ABD39DC21AF5', 'JavaScript:The Good Parts(影印版）', 52, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d2220cc7-dcd9-11f0-b9d3-b44506d77805', 'C3CF52B3ED2D4187A16754551488D733', 'Java从入门到精通（附光盘）', 113, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d222b599-dcd9-11f0-b9d3-b44506d77805', 'C86D3F6FACB449BEBD940D9307ED4A47', '编写高质量代码：改善Java程序的151个建议(从语法、程序设计和架构、工具和框架、编码风格、编程思想5个方面探讨编写高质量Java代码的技巧、禁忌和最佳实践)', 17, 10, 1, '2025-12-19 20:54:13');
INSERT INTO `stock` VALUES ('d2236a26-dcd9-11f0-b9d3-b44506d77805', 'CB0AB3654945411EA69F368D0EA91A00', 'JavaScript语言精粹（修订版）', 120, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d2241e2f-dcd9-11f0-b9d3-b44506d77805', 'CD913617EE964D0DBAF20C60076D32FB', '名师讲坛——Java开发实战经典（配光盘）（60小时全真课堂培训，视频超级给力！790项实例及分析，北京魔乐科技培训中心Java全部精华）', 157, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d225ce90-dcd9-11f0-b9d3-b44506d77805', 'CE01F15D435A4C51B0AD8202A318DCA7', 'Java编程思想（第4版）', 33, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d2267718-dcd9-11f0-b9d3-b44506d77805', 'CF5546769F2842DABB2EF7A00D51F255', 'jQuery开发从入门到精通（配套视频327节，中小实例232个，实战案例7个商品详情手册11部，网页模版83类）（附1DVD）', 65, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d2271c06-dcd9-11f0-b9d3-b44506d77805', 'D0DA36CEE42549FFB299B7C7129761D5', 'Java应用架构设计：模块化模式与OSGi(全球资深Java技术专家的力作，系统、全面地讲解如何将模块化设计思想引入开发中，涵盖18个有助于实现模块化软件架构的模式)', 25, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d227c48a-dcd9-11f0-b9d3-b44506d77805', 'D0E69F85ACAB4C15BB40966E5AA545F1', 'Java并发编程实战（第16届Jolt大奖提名图书，Java并发编程必读佳作', 111, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d2286ed2-dcd9-11f0-b9d3-b44506d77805', 'D2ABA8B06C524632846F27C34568F3CE', 'Java 经典实例', 89, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d2290c6d-dcd9-11f0-b9d3-b44506d77805', 'D8723405BA054C13B52357B8F6AEEC24', '深入理解Java虚拟机：JVM高级特性与最佳实践（第2版）', 105, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d229bae1-dcd9-11f0-b9d3-b44506d77805', 'DC36FD53A1514312A0A9ADD53A583886', 'JavaScript异步编程：设计快速响应的网络应用【掌握JavaScript异步编程必杀技，让代码更具响应度！ 】', 56, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d22a6651-dcd9-11f0-b9d3-b44506d77805', 'DCB64DF0084E486EBF173F729A3A630A', 'Java设计模式(第2版)', 148, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d22b161f-dcd9-11f0-b9d3-b44506d77805', 'DEE7BDC7E0E343149E3C3601D2658171', '疯狂HTML 5/CSS 3/JavaScript讲义(含CD光盘1张)', 180, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d22bc55a-dcd9-11f0-b9d3-b44506d77805', 'DF4E74EEE89B43229BB8212F0B858C38', '精通Hibernate：Java对象持久化技术详解（第2版）(含光盘1张)', 62, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d22c7e79-dcd9-11f0-b9d3-b44506d77805', 'E4F184188C8B4C7BB32D4E76603426AC', '疯狂Java讲义（第2版，附光盘）', 145, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d22d364b-dcd9-11f0-b9d3-b44506d77805', 'EA695342393C4BE48B831FA5E6B0E5C4', '编写可维护的JavaScript《JavaScript高级程序设计》作者Nicholas Zakas最新力作，构建编码风格手册，帮助开发团队从“游击队”走向“正规军”）', 145, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d22dec7c-dcd9-11f0-b9d3-b44506d77805', 'F0E34313BF304CCEBF198BD4E05307B8', 'jQuery Cookbook中文版（jQuery之父鼎力推荐，社区数十位专家倾情力作', 90, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d22e9dd8-dcd9-11f0-b9d3-b44506d77805', 'F6162799E913423EA5CB57BEC65AB1E9', 'JUnit实战(第2版)', 196, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d22f4847-dcd9-11f0-b9d3-b44506d77805', 'F693239BC3B3444C8538ABE7411BB38E', 'Java Web典型模块与项目实战大全（配光盘）', 127, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d22ff196-dcd9-11f0-b9d3-b44506d77805', 'F78C94641DB4475BBA1E72A07DF9B3AE', 'JAVA面向对象编程', 40, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d2309cc7-dcd9-11f0-b9d3-b44506d77805', 'FC232CD9B6E6411BBBB1A5B781D2C3C9', 'Java与模式(含盘)（超多实例和习题，详解设计原则与设计模式）', 191, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d2315801-dcd9-11f0-b9d3-b44506d77805', 'FEC3740CF30E442A94021911A25EF0D7', 'Spring攻略(第2版)(Spring攻略(第2版))', 60, 10, 1, '2025-12-19 20:54:14');
INSERT INTO `stock` VALUES ('d231fe1a-dcd9-11f0-b9d3-b44506d77805', 'FFABBED1E5254BC0B2726EC4ED8ACCDA', '深入理解OSGi：Equinox原理、应用与最佳实践（《深入理解Java虚拟机》作者新作！全面解读最新OSGi R5.0规范，深入讲解OSGi原理和服务，以及Equinox框架的用法和原理）', 165, 10, 1, '2025-12-20 19:47:43');

-- ----------------------------
-- Table structure for system_log
-- ----------------------------
DROP TABLE IF EXISTS `system_log`;
CREATE TABLE `system_log`  (
  `id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '日志ID',
  `operate_time` datetime NOT NULL COMMENT '操作时间',
  `operator` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作用户',
  `action` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作内容',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作状态(success/warning/error)',
  `business_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '业务ID',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作IP',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_operate_time`(`operate_time` ASC) USING BTREE,
  INDEX `idx_operator`(`operator` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_log
-- ----------------------------
INSERT INTO `system_log` VALUES ('1e1a4f41c7874c3ea26e8b60f6a4d4c1', '2025-12-20 19:41:49', 'system', '更新库存信息：商品ID=FFABBED1E5254BC0B2726EC4ED8ACCDA, 最低预警值=10', 'success', 'FFABBED1E5254BC0B2726EC4ED8ACCDA', NULL);
INSERT INTO `system_log` VALUES ('bb6dda5913624516be1da0b172de7ea5', '2025-12-23 06:42:33', 'system', '更新库存数量：商品ID=5a4438a94b514157b0aefdb45f0d6cb7, 原数量=50, 新数量=30', 'success', '5a4438a94b514157b0aefdb45f0d6cb7', NULL);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `uid` char(32) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `loginname` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `loginpass` varchar(60) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `email` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `status` tinyint(1) NULL DEFAULT 0,
  `activationCode` char(64) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL,
  `login_failure_count` int NOT NULL DEFAULT 0 COMMENT '登录失败次数',
  `locked` tinyint(1) NOT NULL DEFAULT 0 COMMENT '账户锁定状态(0:未锁定,1:已锁定)',
  `locked_time` datetime NULL DEFAULT NULL COMMENT '账户锁定时间',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  PRIMARY KEY (`uid`) USING BTREE,
  UNIQUE INDEX `loginname`(`loginname` ASC) USING BTREE,
  INDEX `idx_locked`(`locked` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('063a2bc3b264baa170f536f955dc73fe', 'xxx', '202cb962ac59075b964b07152d234b70', 'a123@qq.com', 1, '1405279A6A8F421A9316066F3DE5EF121AB87D076C8545A3A2441E09BBC2121D', 0, 0, NULL, NULL);
INSERT INTO `user` VALUES ('06B1374AAF244FF6804D4C4292693A80', 'zhangyy', '123', '11@qq.com', 1, '0E4735E5157C4EAABB06782718E2C93DEDEA8DB1DBBF4C80A26DCE2A7B49E47B', 0, 0, NULL, NULL);
INSERT INTO `user` VALUES ('0714f432e88945b4', 'www', '$2a$10$tKS.FOniQ.30ej2iIlF//uhk64UkLdCSS9tSd2LtPjxJXaMtPt3gG', 'www@qq.com', 0, 'c6dd6d64-f743-4c32-93b3-a9078f012e65', 0, 0, NULL, NULL);
INSERT INTO `user` VALUES ('1bb7ed4c7fec470cbb24ba49aed9f94a', 'cccccc', 'e10adc3949ba59abbe56e057f20f883e', 'c@qq.com', 1, '2f09416028f04325b9de909c47da137c', 0, 0, NULL, NULL);
INSERT INTO `user` VALUES ('3165a7333dbe45c78165b3f4db05c63f', 'm0nesy', '17c63807c4681b2565803a21e80d995f', '2490458425@qq.com', 1, '3165a7333dbe45c78165b3f4db05c63f', 0, 0, NULL, NULL);
INSERT INTO `user` VALUES ('5cdebd0f86c211ee8cb0002b67d6086b', 'zhangsan', 'e10adc3949ba59abbe56e057f20f883e', '22@qq.com', 1, '8D62BF8E1C0048C39E1E33403B379483D4714FA8667F4D29A849BF1C53FCFD8D', 0, 0, NULL, NULL);
INSERT INTO `user` VALUES ('7733A909DC8C11F0B9D3B44506D77805', 'dddddd', '88888888a', 'ddd@qq.com', 1, '8857eeef461e46279a2fd904fdb90513', 0, 0, NULL, NULL);
INSERT INTO `user` VALUES ('8e9bc6b37c5144cf', 'niko', '123456', 'niko@qq.com', 1, NULL, 0, 0, NULL, NULL);
INSERT INTO `user` VALUES ('9f9e5445e6f44e80', 's1mple', '5c14260a5c4c97a9f83e04a90c3ff92d', 's1mple@qq.com', 0, '414ccd32-eb49-4bf5-b095-b0467a049425', 0, 0, NULL, NULL);
INSERT INTO `user` VALUES ('a7c7cb8e556e26c5d28b92ea77a718e1', 'zhangsan1', 'Zhang123~', '294544244@qq.com', 1, '899dd9f4b3b64c0082bf1dd0850b892fe7be2ad8c06f4272a4b49f014aa21e4a', 0, 0, NULL, NULL);
INSERT INTO `user` VALUES ('ba7888f5548cedf7160bffd7e455e419', 'zhangsan1234', 'Zhang123~', '2638002006@qq.com', 1, 'be20f49157264eb99e2021ad48ed4dd22204ae7165a647278c2530d962d59175', 0, 0, NULL, NULL);
INSERT INTO `user` VALUES ('c56f72da19623279058136465942a115', 'zhangsan123', '1234', '1122@qq.com', 1, 'F5CD78619D9F4C019D87E8249CD0820571FCB957E061422998F6F6D2ED9C6D0A', 0, 0, NULL, NULL);
INSERT INTO `user` VALUES ('D88A6499DBD311F0B9D3B44506D77805', 'aaaaaa', 'e10adc3949ba59abbe56e057f20f883e', 'aaa@qq.com', 1, 'A6EAA35A54704FA3BDBFF4DEB96A909BA7680ED927614DD1A95A483AD099C7AE', 0, 0, NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;
