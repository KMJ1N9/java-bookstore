package com.gg.goods.controller;

import com.gg.goods.entity.Book;
import com.gg.goods.entity.Cartitem;
import com.gg.goods.service.BookService;
import com.gg.goods.service.CartitemService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping({"/book", "/"})
@Slf4j
public class BookController {
    @Autowired
    private BookService bookService;

    @Autowired
    private CartitemService cartitemService;

    /*2.查询单本*/

    @RequestMapping("/getBookByBid")
    public String getBookByBid(String bid, Model model) {
        Book book = bookService.getBookByBid(bid);
        model.addAttribute("book", book);
        return "jsps/book/desc";
    }

    /*从图书详情页添加到购物车*/
    @RequestMapping("/addBookToCart")
    public String addBookToCart(String bid, Integer quantity, String uid) {
        // 创建购物车项
        Cartitem cartitem = new Cartitem();
        cartitem.setCartitemid(UUID.randomUUID().toString().replace("-", ""));
        cartitem.setBid(bid);
        cartitem.setUid(uid);
        cartitem.setQuantity(quantity);
        cartitem.setShunxu(0); // 默认为0，后续可以根据业务逻辑调整

        // 调用购物车服务添加到购物车
        cartitemService.addCart(cartitem);

        return "redirect:/cart/getCartitemsByUid?uid=" + uid;
    }


    /*1.多条件查询多本图书  */
    @RequestMapping("/getBooksByCase")
    public String getBooksByCase(Book book,
                                 Model model,
                                 @RequestParam(defaultValue = "1", required = false)
                                 Integer pageNum, HttpServletRequest request) {
        /*分页先启动分页，然后封装一个分页信息对象，把分页信息对象放到模型中。页面处理分页信息对象*/
        /*
         * pageNum : 当前的页码
         * pageSize : 每页显示的记录数    8
         *
         * 1.启动分页要在查询回来结果集之前进行。
         * 2.查询回来结果集后，要创建分页信息对象。
         * */
        PageHelper.startPage(pageNum, 8);
        List<Book> books = bookService.getBooksByCase(book);
        PageInfo<Book> info = new PageInfo<Book>(books);
//        info.getPages() 一共多少页

//        model.addAttribute("books", books);
        model.addAttribute("pageinfo", info);


        /*获取请求的路径*/
        /*http://goods/book/getBooksByCase?xxx=XXX&cid=xxx&pageNum=1*/
        String uri = request.getRequestURI() + "?xxx=XXX";
        log.debug("请求URI: {}", uri);
        /*cid,bname,author,press*/
        if (book.getPress() != null) {
            uri += "&press=" + book.getPress();
        }
        if (book.getAuthor() != null) {
            uri += "&author=" + book.getAuthor();
        }
        if (book.getBname() != null) {
            uri += "&bname=" + book.getBname();
        }
        if (book.getCid() != null) {
            uri += "&cid=" + book.getCid();
        }
        model.addAttribute("uri", uri);
        return "jsps/book/list";
    }

    /*添加图书页面*/
    @RequestMapping("/addBookPage")
    public String addBookPage() {
        return "jsps/book/addBook";
    }

    /*添加图书处理*/
    @RequestMapping("/addBook")
    public String addBook(Book book, Model model) {
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
        return "jsps/book/message";
    }

    /*修改图书页面*/
    @RequestMapping("/editBookPage")
    public String editBookPage(String bid, Model model) {
        Book book = bookService.getBookByBid(bid);
        model.addAttribute("book", book);
        return "jsps/book/editBook";
    }

    /*修改图书处理*/
    @RequestMapping("/editBook")
    public String editBook(Book book, Model model) {
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
        return "jsps/book/message";
    }

    /*删除图书*/
    @RequestMapping("/deleteBook")
    public String deleteBook(String bid, Model model) {
        int result = bookService.deleteBook(bid);
        if (result > 0) {
            model.addAttribute("message", "删除图书成功");
        } else {
            model.addAttribute("message", "删除图书失败");
        }
        return "jsps/book/message";
    }

    /*根据分类ID查询图书*/
    @RequestMapping("/getBooksByCid")
    public String getBooksByCid(String cid,
                                @RequestParam(defaultValue = "1", required = false) Integer pageNum,
                                Model model) {
        PageHelper.startPage(pageNum, 8);
        List<Book> books = bookService.getBooksByCid(cid);
        PageInfo<Book> info = new PageInfo<>(books);
        model.addAttribute("pageinfo", info);
        return "jsps/book/list";
    }

    /*搜索图书（根据书名）*/
    @RequestMapping("/searchBooks")
    public String searchBooks(String keyword,
                              @RequestParam(defaultValue = "1", required = false) Integer pageNum,
                              Model model) {
        PageHelper.startPage(pageNum, 8);
        List<Book> books = bookService.searchBooks(keyword);
        PageInfo<Book> info = new PageInfo<>(books);
        model.addAttribute("pageinfo", info);
        return "jsps/book/list";
    }

    /*首页展示最新图书*/
    @RequestMapping("/getNewestBooks")
    public String getNewestBooks(@RequestParam(defaultValue = "8", required = false) Integer limit,
                                 Model model) {
        List<Book> books = bookService.getNewestBooks(limit);
        model.addAttribute("newestBooks", books);
        return "index";
    }

    /*首页展示热门图书*/
    @RequestMapping("/getHotBooks")
    public String getHotBooks(@RequestParam(defaultValue = "8", required = false) Integer limit,
                              Model model) {
        List<Book> books = bookService.getHotBooks(limit);
        model.addAttribute("hotBooks", books);
        return "index";
    }

    /*首页（默认）*/
    @RequestMapping("/index")
    @Cacheable(value = "pages", key = "'index'", sync = true)
    public String index(Model model) {
        // 获取最新图书
        List<Book> newestBooks = bookService.getNewestBooks(8);
        model.addAttribute("newestBooks", newestBooks);

        // 获取热门图书
        List<Book> hotBooks = bookService.getHotBooks(8);
        model.addAttribute("hotBooks", hotBooks);

        return "index";
    }

    /*更新图书统计信息（销量/浏览量）*/
    @RequestMapping("/updateStatistics")
    public void updateStatistics(String bid, Integer type, Integer increment) {
        bookService.updateBookStatistics(bid, type, increment);
    }
}

