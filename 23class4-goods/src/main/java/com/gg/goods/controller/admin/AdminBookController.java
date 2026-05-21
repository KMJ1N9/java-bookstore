package com.gg.goods.controller.admin;

import com.gg.goods.entity.Book;
import com.gg.goods.povos.CategoryPovo;
import com.gg.goods.service.BookService;
import com.gg.goods.service.CategoryService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/admin/book")
public class AdminBookController {

    @Autowired
    private BookService bookService;

    @Autowired
    private CategoryService categoryService;

    /**
     * 商品列表页面
     */
    @RequestMapping("/list")
    public String list(Book book,
                       Model model,
                       @RequestParam(defaultValue = "1", required = false) Integer pageNum) {
        // 启动分页
        PageHelper.startPage(pageNum, 10);
        List<Book> books = bookService.getBooksByCase(book);
        PageInfo<Book> pageInfo = new PageInfo<>(books);

        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("book", book);
        return "jsps/admin/book/list";
    }

    /**
     * 跳转到添加商品页面
     */
    @RequestMapping("/addPage")
    public String addPage(Model model) {
        // 获取所有分类信息（包括一级和二级分类的层次结构）
        List<CategoryPovo> categories = categoryService.loadCategories();
        model.addAttribute("categories", categories);
        return "jsps/admin/book/add";
    }

    /**
     * 添加商品
     */
    @RequestMapping("/add")
    public String add(Book book, Model model) {
        // 生成图书ID
        book.setBid(UUID.randomUUID().toString().replace("-", ""));
        // 计算折扣
        if (book.getPrice() != null && book.getCurrprice() != null) {
            book.setDiscount(book.getCurrprice().divide(book.getPrice(), 2, RoundingMode.HALF_UP).multiply(new BigDecimal(10)));
        }
        int result = bookService.createBook(book);
        if (result > 0) {
            model.addAttribute("message", "添加图书成功");
        } else {
            model.addAttribute("message", "添加图书失败");
        }
        return "jsps/admin/book/message";
    }

    /**
     * 跳转到编辑商品页面
     */
    @RequestMapping("/editPage")
    public String editPage(String bid, Model model) {
        Book book = bookService.getBookByBid(bid);
        model.addAttribute("book", book);
        return "jsps/admin/book/edit";
    }

    /**
     * 编辑商品
     */
    @RequestMapping("/edit")
    public String edit(Book book, Model model) {
        // 计算折扣
        if (book.getPrice() != null && book.getCurrprice() != null) {
            book.setDiscount(book.getCurrprice().divide(book.getPrice(), 2, RoundingMode.HALF_UP).multiply(new BigDecimal(10)));
        }
        int result = bookService.updateBook(book);
        if (result > 0) {
            model.addAttribute("message", "修改图书成功");
        } else {
            model.addAttribute("message", "修改图书失败");
        }
        return "jsps/admin/book/message";
    }

    /**
     * 删除商品
     */
    @RequestMapping("/delete")
    public String delete(String bid, Model model) {
        int result = bookService.deleteBook(bid);
        if (result > 0) {
            model.addAttribute("message", "删除图书成功");
        } else {
            model.addAttribute("message", "删除图书失败");
        }
        return "jsps/admin/book/message";
    }
}