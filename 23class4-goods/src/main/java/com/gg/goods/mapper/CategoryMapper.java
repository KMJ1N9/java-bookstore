package com.gg.goods.mapper;

import com.gg.goods.entity.Category;
import com.gg.goods.povos.CategoryPovo;

import java.util.List;

/**
 * @Entity com.gg.goods.entity.Category
 */
public interface CategoryMapper {

    int deleteByPrimaryKey(Long id);

    int insert(Category record);

    int insertSelective(Category record);

    Category selectByPrimaryKey(Long id);

    int updateByPrimaryKeySelective(Category record);

    int updateByPrimaryKey(Category record);

    /*主发射器，负责查询所有的一级类别*/
    /*select  *  from  category  where pid is  NULL */
    List<CategoryPovo> selectCategoryPovos();

    /*从发射器，负责查询每个一级类别下，对应的二级类别们*/
    List<Category> selectCategoryByPid(String pid);
}
