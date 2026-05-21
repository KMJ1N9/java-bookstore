package com.gg.goods.controller;

import com.gg.goods.entity.Category;
import com.gg.goods.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/category")
public class CategoryController {
    @Autowired
    private CategoryService categoryService;

    /*分类列表页面*/
    @RequestMapping("/list")
    @Cacheable(value = "pages", key = "'categoryList'", sync = true)
    public String list(Model model) {
        // 获取所有一级分类
        List<Category> firstLevelCategories = categoryService.getFirstLevelCategories();
        model.addAttribute("firstLevelCategories", firstLevelCategories);
        return "jsps/category/list";
    }

    /*添加分类页面*/
    @RequestMapping("/addPage")
    public String addPage(Model model) {
        // 获取所有一级分类（用于选择父分类）
        List<Category> firstLevelCategories = categoryService.getFirstLevelCategories();
        model.addAttribute("firstLevelCategories", firstLevelCategories);
        return "jsps/category/add";
    }

    /*添加分类处理*/
    @RequestMapping("/add")
    public String add(Category category, Model model) {
        int result = categoryService.createCategory(category);
        if (result > 0) {
            model.addAttribute("message", "添加分类成功");
        } else {
            model.addAttribute("message", "添加分类失败");
        }
        return "jsps/category/message";
    }

    /*修改分类页面*/
    @RequestMapping("/editPage")
    public String editPage(String cid, Model model) {
        Category category = categoryService.getCategoryByCid(cid);
        List<Category> firstLevelCategories = categoryService.getFirstLevelCategories();
        model.addAttribute("category", category);
        model.addAttribute("firstLevelCategories", firstLevelCategories);
        return "jsps/category/edit";
    }

    /*修改分类处理*/
    @RequestMapping("/edit")
    public String edit(Category category, Model model) {
        int result = categoryService.updateCategory(category);
        if (result > 0) {
            model.addAttribute("message", "修改分类成功");
        } else {
            model.addAttribute("message", "修改分类失败");
        }
        return "jsps/category/message";
    }

    /*删除分类*/
    @RequestMapping("/delete")
    public String delete(String cid, Model model) {
        // 先检查是否有子分类
        List<Category> subCategories = categoryService.getSecondLevelCategories(cid);
        if (subCategories != null && !subCategories.isEmpty()) {
            model.addAttribute("message", "该分类下有子分类，无法删除");
            return "jsps/category/message";
        }

        int result = categoryService.deleteCategory(cid);
        if (result > 0) {
            model.addAttribute("message", "删除分类成功");
        } else {
            model.addAttribute("message", "删除分类失败");
        }
        return "jsps/category/message";
    }

    /*获取二级分类（AJAX使用）*/
    @RequestMapping("/getSecondLevel")
    public String getSecondLevel(String pid, Model model) {
        List<Category> secondLevelCategories = categoryService.getSecondLevelCategories(pid);
        model.addAttribute("secondLevelCategories", secondLevelCategories);
        return "jsps/category/second_level_list";
    }
}
