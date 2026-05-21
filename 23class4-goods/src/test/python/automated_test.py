#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
项目自动化测试脚本
测试所有主要模块的功能
"""

import unittest
import requests
import time
from bs4 import BeautifulSoup
import re

# 项目基础URL
BASE_URL = "http://localhost:8080/goods"

# 测试账户信息
TEST_USER = {
    "username": "testuser",
    "password": "test123456"
}

TEST_ADMIN = {
    "username": "admin",
    "password": "admin123456"
}


class BaseTest(unittest.TestCase):
    """测试基类，包含通用的设置和清理方法"""
    
    def setUp(self):
        """测试前的设置工作"""
        self.session = requests.Session()
        self.headers = {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        }
    
    def tearDown(self):
        """测试后的清理工作"""
        self.session.close()
    
    def login_user(self):
        """用户登录"""
        # 获取登录页面
        login_page = self.session.get(f"{BASE_URL}/jsps/user/login.jsp", headers=self.headers)
        self.assertEqual(login_page.status_code, 200, "获取登录页面失败")
        
        # 提交登录表单
        login_url = f"{BASE_URL}/user/login"
        login_data = {
            "username": TEST_USER["username"],
            "password": TEST_USER["password"]
        }
        
        response = self.session.post(login_url, data=login_data, headers=self.headers)
        self.assertEqual(response.status_code, 200, f"用户登录请求失败: {response.status_code}")
        
        # 检查是否登录成功（通常会重定向或在页面中显示用户名）
        if "login" in response.url or "err_msg" in response.text:
            self.fail(f"用户登录失败: {response.text[:500]}...")
        
        return True
    
    def login_admin(self):
        """管理员登录"""
        # 获取管理员登录页面
        login_page = self.session.get(f"{BASE_URL}/jsps/admin/login.jsp", headers=self.headers)
        self.assertEqual(login_page.status_code, 200, "获取管理员登录页面失败")
        
        # 提交登录表单
        login_url = f"{BASE_URL}/admin/login"
        login_data = {
            "username": TEST_ADMIN["username"],
            "password": TEST_ADMIN["password"]
        }
        
        response = self.session.post(login_url, data=login_data, headers=self.headers)
        self.assertEqual(response.status_code, 200, f"管理员登录请求失败: {response.status_code}")
        
        # 检查是否登录成功
        if "login" in response.url or "err_msg" in response.text:
            self.fail(f"管理员登录失败: {response.text[:500]}...")
        
        return True
    
    def get_csrf_token(self, html_content):
        """从HTML内容中提取CSRF令牌"""
        soup = BeautifulSoup(html_content, "html.parser")
        csrf_input = soup.find("input", {"name": "_csrf"})
        if csrf_input and "value" in csrf_input.attrs:
            return csrf_input["value"]
        
        # 尝试从meta标签中获取
        csrf_meta = soup.find("meta", {"name": "_csrf"})
        if csrf_meta and "content" in csrf_meta.attrs:
            return csrf_meta["content"]
        
        return None
    
    def check_page_title(self, response, expected_title):
        """检查页面标题是否包含预期内容"""
        soup = BeautifulSoup(response.text, "html.parser")
        title = soup.title.string if soup.title else ""
        self.assertIn(expected_title, title, f"页面标题不包含预期内容: {title}")


class UserAuthenticationTest(BaseTest):
    """用户认证模块测试"""
    
    def test_user_login(self):
        """测试用户登录功能"""
        self.login_user()
        print("✓ 用户登录测试通过")
    
    def test_user_logout(self):
        """测试用户登出功能"""
        # 先登录
        self.login_user()
        
        # 登出
        logout_url = f"{BASE_URL}/user/logout"
        response = self.session.get(logout_url, headers=self.headers)
        self.assertEqual(response.status_code, 200, f"用户登出失败: {response.status_code}")
        
        # 检查是否登出成功（应该跳转到登录页面或主页）
        self.assertIn("login" in response.url or "index" in response.url, True, "用户登出后未正确跳转")
        print("✓ 用户登出测试通过")
    
    def test_admin_login(self):
        """测试管理员登录功能"""
        self.login_admin()
        print("✓ 管理员登录测试通过")


class BookModuleTest(BaseTest):
    """图书模块测试"""
    
    def test_book_list(self):
        """测试图书列表页面"""
        response = self.session.get(f"{BASE_URL}/", headers=self.headers)
        self.assertEqual(response.status_code, 200, "获取图书列表页面失败")
        
        # 检查页面是否包含图书相关内容
        soup = BeautifulSoup(response.text, "html.parser")
        book_elements = soup.find_all("div", class_=re.compile(r"book|item"))
        self.assertTrue(len(book_elements) > 0, "图书列表页面不包含图书元素")
        print("✓ 图书列表页面测试通过")
    
    def test_book_detail(self):
        """测试图书详情页面"""
        # 先获取图书列表页面
        list_response = self.session.get(f"{BASE_URL}/", headers=self.headers)
        self.assertEqual(list_response.status_code, 200, "获取图书列表页面失败")
        
        # 从列表中提取第一本图书的ID
        soup = BeautifulSoup(list_response.text, "html.parser")
        book_links = soup.find_all("a", href=re.compile(r"/book/getBookByBid\?bid="))
        
        if book_links:
            first_book_url = book_links[0]["href"]
            if not first_book_url.startswith("http"):
                first_book_url = BASE_URL + first_book_url
            
            # 访问图书详情页面
            detail_response = self.session.get(first_book_url, headers=self.headers)
            self.assertEqual(detail_response.status_code, 200, "获取图书详情页面失败")
            
            # 检查页面是否包含图书详情
            self.assertIn("图书详情", detail_response.text, "图书详情页面不包含预期内容")
            print("✓ 图书详情页面测试通过")
        else:
            print("⚠ 未找到图书链接，跳过图书详情测试")


class CategoryModuleTest(BaseTest):
    """分类模块测试"""
    
    def test_category_list(self):
        """测试分类列表页面"""
        response = self.session.get(f"{BASE_URL}/category/list", headers=self.headers)
        self.assertEqual(response.status_code, 200, "获取分类列表页面失败")
        
        # 检查页面是否包含分类相关内容
        self.assertIn("分类列表", response.text, "分类列表页面不包含预期内容")
        print("✓ 分类列表页面测试通过")


class CartModuleTest(BaseTest):
    """购物车模块测试"""
    
    def test_cart_access(self):
        """测试购物车访问"""
        # 先登录
        self.login_user()
        
        # 访问购物车页面
        cart_url = f"{BASE_URL}/cart/list"
        response = self.session.get(cart_url, headers=self.headers)
        self.assertEqual(response.status_code, 200, "获取购物车页面失败")
        
        # 检查页面是否包含购物车相关内容
        self.assertIn("购物车", response.text, "购物车页面不包含预期内容")
        print("✓ 购物车页面测试通过")


class OrderModuleTest(BaseTest):
    """订单模块测试"""
    
    def test_order_list(self):
        """测试订单列表页面"""
        # 先登录
        self.login_user()
        
        # 访问订单列表页面
        orders_url = f"{BASE_URL}/order/list"
        response = self.session.get(orders_url, headers=self.headers)
        self.assertEqual(response.status_code, 200, "获取订单列表页面失败")
        
        # 检查页面是否包含订单相关内容
        self.assertIn("我的订单", response.text, "订单列表页面不包含预期内容")
        print("✓ 订单列表页面测试通过")


class AdminModuleTest(BaseTest):
    """管理员模块测试"""
    
    def test_admin_dashboard(self):
        """测试管理员仪表盘"""
        # 先登录管理员
        self.login_admin()
        
        # 访问仪表盘
        dashboard_url = f"{BASE_URL}/admin/dashboard"
        response = self.session.get(dashboard_url, headers=self.headers)
        self.assertEqual(response.status_code, 200, "访问管理员仪表盘失败")
        
        # 检查页面是否包含仪表盘相关内容
        self.assertIn("管理员仪表盘", response.text, "管理员仪表盘不包含预期内容")
        print("✓ 管理员仪表盘测试通过")
    
    def test_admin_book_management(self):
        """测试管理员图书管理"""
        # 先登录管理员
        self.login_admin()
        
        # 访问图书管理页面
        books_url = f"{BASE_URL}/admin/book/list"
        response = self.session.get(books_url, headers=self.headers)
        self.assertEqual(response.status_code, 200, "访问管理员图书管理页面失败")
        
        # 检查页面是否包含图书管理相关内容
        self.assertIn("图书管理", response.text, "管理员图书管理页面不包含预期内容")
        print("✓ 管理员图书管理测试通过")
    
    def test_admin_user_management(self):
        """测试管理员用户管理"""
        # 先登录管理员
        self.login_admin()
        
        # 访问用户管理页面
        users_url = f"{BASE_URL}/admin/user/list"
        response = self.session.get(users_url, headers=self.headers)
        self.assertEqual(response.status_code, 200, "访问管理员用户管理页面失败")
        
        # 检查页面是否包含用户管理相关内容
        self.assertIn("用户管理", response.text, "管理员用户管理页面不包含预期内容")
        print("✓ 管理员用户管理测试通过")


class CacheModuleTest(BaseTest):
    """缓存模块测试"""
    
    def test_cache_warmup(self):
        """测试缓存预热"""
        # 先登录管理员
        self.login_admin()
        
        # 执行缓存预热
        warmup_url = f"{BASE_URL}/admin/cache/warmup"
        response = self.session.get(warmup_url, headers=self.headers)
        self.assertEqual(response.status_code, 200, "执行缓存预热失败")
        
        print("✓ 缓存预热测试通过")


class SystemIntegrationTest(BaseTest):
    """系统集成测试"""
    
    def test_navigation_flow(self):
        """测试主要导航流程"""
        # 首页 → 图书列表 → 图书详情 → 购物车 → 登录
        
        # 1. 访问首页
        index_response = self.session.get(f"{BASE_URL}/", headers=self.headers)
        self.assertEqual(index_response.status_code, 200, "访问首页失败")
        
        # 2. 访问图书列表
        books_response = self.session.get(f"{BASE_URL}/book/getBooksByCase", headers=self.headers)
        self.assertEqual(books_response.status_code, 200, "访问图书列表失败")
        
        # 3. 访问购物车页面（会跳转到登录页面）
        cart_response = self.session.get(f"{BASE_URL}/cart/list", headers=self.headers)
        self.assertEqual(cart_response.status_code, 200, "访问购物车页面失败")
        
        print("✓ 系统导航流程测试通过")


if __name__ == "__main__":
    print("=" * 60)
    print("开始执行自动化测试")
    print(f"测试项目: {BASE_URL}")
    print(f"测试时间: {time.strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 60)
    
    # 运行所有测试
    unittest.main(verbosity=2)