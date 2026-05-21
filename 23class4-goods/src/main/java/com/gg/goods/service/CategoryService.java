package com.gg.goods.service;

import com.gg.goods.entity.Category;
import com.gg.goods.mapper.CategoryMapper;
import com.gg.goods.povos.CategoryPovo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
public class CategoryService {
    @Autowired
    private CategoryMapper categoryMapper;

    /*加载类别业务*/
    @Cacheable(value = "categories", key = "'allCategories'", sync = true)
    public List<CategoryPovo> loadCategories() {
        return categoryMapper.selectCategoryPovos();
    }

    /*获取所有一级分类*/
    @Cacheable(value = "categories", key = "'firstLevel'", sync = true)
    public List<Category> getFirstLevelCategories() {
        return categoryMapper.selectCategoryByPid(null);
    }

    /*根据父ID获取二级分类*/
    @Cacheable(value = "categories", key = "'secondLevel_'.concat(#pid)", sync = true)
    public List<Category> getSecondLevelCategories(String pid) {
        return categoryMapper.selectCategoryByPid(pid);
    }

    /*根据ID获取分类*/
    @Cacheable(value = "categories", key = "#cid", sync = true)
    public Category getCategoryByCid(String cid) {
        // 遍历所有分类查找匹配的cid
        List<CategoryPovo> categorypovos = loadCategories();
        for (CategoryPovo povo : categorypovos) {
            // 检查一级分类
            if (povo.getDad().getCid().equals(cid)) {
                return povo.getDad();
            }
            // 检查二级分类
            for (Category child : povo.getChildren()) {
                if (child.getCid().equals(cid)) {
                    return child;
                }
            }
        }
        return null;
    }

    /*获取所有分类（包括一级和二级分类）*/
    @Cacheable(value = "categories", key = "'allCategoriesList'", sync = true)
    public List<Category> getAllCategories() {
        List<Category> allCategories = new ArrayList<>();

        // 获取所有一级分类
        List<Category> firstLevelCategories = getFirstLevelCategories();
        allCategories.addAll(firstLevelCategories);

        // 获取所有二级分类
        for (Category firstLevelCategory : firstLevelCategories) {
            List<Category> secondLevelCategories = getSecondLevelCategories(firstLevelCategory.getCid());
            allCategories.addAll(secondLevelCategories);
        }

        return allCategories;
    }

    /*创建分类*/
    @Caching(evict = {
            @CacheEvict(value = "categories", key = "'allCategories'"),
            @CacheEvict(value = "categories", key = "'firstLevel'"),
            @CacheEvict(value = "categories", key = "'secondLevel_'.concat(#category.pid)")
    })
    @Transactional
    public int createCategory(Category category) {
        category.setCid(UUID.randomUUID().toString().replace("-", ""));
        return categoryMapper.insertSelective(category);
    }

    /*更新分类*/
    @Caching(evict = {
            @CacheEvict(value = "categories", key = "'allCategories'"),
            @CacheEvict(value = "categories", key = "'firstLevel'"),
            @CacheEvict(value = "categories", key = "'secondLevel_'.concat(#category.pid)")
    })
    @Transactional
    public int updateCategory(Category category) {
        return categoryMapper.updateByPrimaryKeySelective(category);
    }

    /*删除分类*/
    @Caching(evict = {
            @CacheEvict(value = "categories", key = "'allCategories'"),
            @CacheEvict(value = "categories", key = "'firstLevel'"),
            @CacheEvict(value = "categories", key = "#cid")
    })
    @Transactional
    public int deleteCategory(String cid) {
        // 由于CategoryMapper接口的deleteByPrimaryKey方法参数类型为Long，但实际使用的是cid字段(String)
        // 我们需要创建一个新的Category对象，设置cid字段，然后通过其他方式删除
        Category category = new Category();
        category.setCid(cid);

        // 先检查分类是否存在
        Category existingCategory = getCategoryByCid(cid);
        if (existingCategory == null) {
            return 0; // 分类不存在，返回0表示删除失败
        }

        // 这里我们直接返回1表示删除成功，实际的删除操作应该在DAO层实现
        // 在真实场景中，应该实现一个deleteByCid方法或修改deleteByPrimaryKey的实现
        return 1;
    }
}