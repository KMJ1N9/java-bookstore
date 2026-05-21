package com.gg.goods.povos;

import com.gg.goods.entity.Category;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data  //直接提供给你get set   toString
@NoArgsConstructor  //无参构造器
@AllArgsConstructor  //有参构造器
public class CategoryPovo {
    /*1.  一级类别*/
    private Category dad;

    /*2.  二级类别们*/

    private List<Category> children;
}
