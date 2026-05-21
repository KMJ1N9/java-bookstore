package com.gg.goods.controller;

import com.gg.goods.entity.Book;
import com.gg.goods.entity.Stock;
import com.gg.goods.service.BookService;
import com.gg.goods.service.StockService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/stock")
public class StockController {
    @Autowired
    private StockService stockService;
    @Autowired
    private BookService bookService;

    /*库存列表页面*/
    @RequestMapping("/list")
    public String list(Model model) {
        List<Stock> stocks = stockService.getAllStocks();
        model.addAttribute("stocks", stocks);
        return "jsps/stock/list";
    }

    /*库存不足预警页面*/
    @RequestMapping("/lowStock")
    public String lowStock(Model model) {
        List<Stock> lowStocks = stockService.getLowStocks();
        model.addAttribute("lowStocks", lowStocks);
        return "jsps/stock/low_stock";
    }

    /*添加库存页面*/
    @RequestMapping("/addPage")
    public String addPage(Model model) {
        // 获取所有图书信息，用于选择要添加库存的图书
        List<Book> books = bookService.getBooksByCase(null);
        model.addAttribute("books", books);
        return "jsps/stock/add";
    }

    /*添加库存处理*/
    @RequestMapping("/add")
    public String add(Stock stock, Model model) {
        // 检查该图书是否已有库存记录
        Stock existingStock = stockService.getStockByBid(stock.getBid());
        if (existingStock != null) {
            model.addAttribute("message", "该图书已有库存记录，请使用修改功能");
            return "jsps/stock/message";
        }

        int result = stockService.createStock(stock);
        if (result > 0) {
            model.addAttribute("message", "添加库存成功");
        } else {
            model.addAttribute("message", "添加库存失败");
        }
        return "jsps/stock/message";
    }

    /*修改库存页面*/
    @RequestMapping("/editPage")
    public String editPage(String bid, Model model) {
        Stock stock = stockService.getStockByBid(bid);
        Book book = bookService.getBookByBid(bid);
        model.addAttribute("stock", stock);
        model.addAttribute("book", book);
        return "jsps/stock/edit";
    }

    /*修改库存处理*/
    @RequestMapping("/edit")
    public String edit(Stock stock, Model model) {
        int result = stockService.updateStockQuantity(stock.getBid(), stock.getQuantity());
        if (result > 0) {
            // 同时更新预警值
            stockService.updateMinQuantity(stock.getBid(), stock.getMinQuantity());
            model.addAttribute("message", "修改库存成功");
        } else {
            model.addAttribute("message", "修改库存失败");
        }
        return "jsps/stock/message";
    }

    /*入库操作*/
    @RequestMapping("/inStock")
    public String inStock(String bid, Integer quantity, Model model) {
        if (quantity == null || quantity <= 0) {
            model.addAttribute("message", "入库数量必须大于0");
            return "jsps/stock/message";
        }

        int result = stockService.increaseStock(bid, quantity);
        if (result > 0) {
            model.addAttribute("message", "入库成功，数量：" + quantity);
        } else {
            model.addAttribute("message", "入库失败，请检查该图书是否有库存记录");
        }
        return "jsps/stock/message";
    }

    /*出库操作（用于销售）*/
    @RequestMapping("/outStock")
    public String outStock(String bid, Integer quantity, Model model) {
        if (quantity == null || quantity <= 0) {
            model.addAttribute("message", "出库数量必须大于0");
            return "jsps/stock/message";
        }

        Stock stock = stockService.getStockByBid(bid);
        if (stock == null) {
            model.addAttribute("message", "该图书没有库存记录");
            return "jsps/stock/message";
        }

        if (stock.getQuantity() < quantity) {
            model.addAttribute("message", "库存不足，当前库存：" + stock.getQuantity());
            return "jsps/stock/message";
        }

        int result = stockService.decreaseStock(bid, quantity);
        if (result > 0) {
            model.addAttribute("message", "出库成功，数量：" + quantity);
        } else {
            model.addAttribute("message", "出库失败");
        }
        return "jsps/stock/message";
    }

    /*刷新库存状态*/
    @RequestMapping("/refreshStatus")
    public String refreshStatus(Model model) {
        stockService.checkAndUpdateStockStatus();
        model.addAttribute("message", "库存状态刷新成功");
        return "jsps/stock/message";
    }

    /*查看库存详情*/
    @RequestMapping("/detail")
    public String detail(String bid, Model model) {
        Stock stock = stockService.getStockByBid(bid);
        Book book = bookService.getBookByBid(bid);

        Map<String, Object> detail = new HashMap<>();
        detail.put("stock", stock);
        detail.put("book", book);

        model.addAttribute("detail", detail);
        return "jsps/stock/detail";
    }
}