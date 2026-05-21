package com.gg.goods.povos;

import com.gg.goods.entity.Book;
import com.gg.goods.entity.Cartitem;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data  //直接提供给你get set   toString
@NoArgsConstructor  //无参构造器
@AllArgsConstructor  //有参构造器
public class CartBookPovo {

    private Cartitem cartitem;
    private Book book;

    /*  ${povo.subtotal}*/
    public BigDecimal getSubtotal() {
        /*只有字符串初始化，不丢失精度*/
        BigDecimal count = new BigDecimal(cartitem.getQuantity().toString());
        BigDecimal price = book.getCurrprice();
        return count.multiply(price);
    }
}
