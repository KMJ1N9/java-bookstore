package com.gg.goods.controller;

import com.gg.goods.entity.User;
import com.gg.goods.exception.BusinessException;
import com.gg.goods.helpers.PasswordHelper;
import com.gg.goods.helpers.Verify;
import com.gg.goods.povos.ActivationPovo;
import com.gg.goods.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Controller
/*标记 二级模块请求路径*/
@RequestMapping("/user")
@Slf4j
public class UserController {
    @Autowired
    private UserService userService;


    /*用户登出*/
    @RequestMapping("/logout")
    public String logout(HttpSession session) {
        /*杀死Session*/
        session.invalidate();
        return "redirect:/index.jsp";
    }

    /*4.校验验证码*/
    @RequestMapping("/verifyVerifyCode")
    @ResponseBody
    public Boolean verifyVerifyCode(String val, HttpSession session) {
        /*获取用户输入的val ,和Session中的  vCode对应真值 比较*/
        /*1.获取session中的真值*/
        String right_code = (String) session.getAttribute("vCode");
        /*2.比较*/
        log.debug("验证码验证 - 用户输入: {}, Session中存储: {}", val, right_code);
        if (right_code != null && val != null && val.equalsIgnoreCase(right_code)) {
            log.debug("验证码验证成功");
            return true;
        }
        log.debug("验证码验证失败");
        return false;
    }

    /*用户登录*/
    @RequestMapping("/login")
    public String login(User user, Model model, HttpSession session) {
        try {
            // 验证码已移除，直接验证用户名和密码
            User u = userService.login(user);
            if (u != null) {
                /*用户名，密码正确*/
                if (u.getStatus() == 0) {
                    /*没激活*/
                    model.addAttribute("err_msg",
                            "当前用户未激活，请尽快到邮箱中激活");
                    return "jsps/user/login";
                } else {
                    /*激活了*/
                    /*!!!登陆潜规则：一但登录成功，要把查询回来的满值的User对象，放到Session域里 */
                    session.setAttribute("user", u);
                    // 记录会话创建时间，用于项目重启后验证会话有效性
                    session.setAttribute("sessionCreatedTime", System.currentTimeMillis());
                    // 修改为重定向到明确的主页面路径，而不是根路径，避免拦截器处理问题
                    return "redirect:/jsps/main.jsp";
                }
            } else {
                /*用户名，密码 错误*/
                model.addAttribute("err_msg",
                        "用户名或密码错误");
                return "jsps/user/login";
            }
        } catch (BusinessException e) {
            // 捕获业务异常，通常是用户名或密码错误
            log.warn("登录业务异常: {}", e.getMessage());
            model.addAttribute("err_msg", e.getMessage());
            return "jsps/user/login";
        } catch (Exception e) {
            // 捕获所有其他异常
            log.error("登录过程发生异常: {}", e.getMessage());
            e.printStackTrace();
            // 设置友好的错误信息
            model.addAttribute("err_msg", "登录失败，请稍后重试或联系管理员");
            return "jsps/user/login";
        }
    }


    /*用户激活*/
    @RequestMapping("/activation")
    public String activation(String code, Model model) {
        ActivationPovo activationPovo = userService.activation(code);
        if (activationPovo.getFlag()) {
            model.addAttribute("code", "success");
        } else {
            model.addAttribute("code", "error");
        }
        model.addAttribute("msg", activationPovo.getMsg());

        return "jsps/msg";
    }


    /*用户注册*/
    @RequestMapping("/regist")
    /*
     * 三个请求参数 loginname  loginpass email 自动封装到user对象中
     * */
    /*1.User user 获取请求参数*/
    public String regist(User user, Model model) {

        boolean res = userService.regist(user);
        /*
         * msg.jsp   code显示对号还是错号 ,  msg提示信息
         * */
        /*2.域中传值，跨路径传值
         *   /user/regist  =>  msg.jsp
         * */
        if (res) {
            /*注册成功*/
            model.addAttribute("code", "success");
            model.addAttribute("msg", "恭喜，请尽快到邮箱中激活！");
        } else {
            /*注册失败*/
            model.addAttribute("code", "error");
            model.addAttribute("msg", "注册失败请尝试重新注册！");
        }
        /*3.页面跳转*/
        return "jsps/msg";
    }

    /*
     * 3.生成验证码
     * */
    @RequestMapping("/createVerifycode")
    public void createVerifycode(HttpServletRequest request, HttpServletResponse response) throws IOException {
        log.debug("创建验证码请求到达");
        Verify.getVirify(request, response);
    }


    /*1.校验用户名是否可用*/
    @RequestMapping("/verifyLoginname")
    /*调用了JackSon第三包，专门返回引用类型*/
    @ResponseBody
    public Boolean verifyLoginname(String loginname) {
        /*调用业务层实现得知用户名是否可用*/
        return userService.verifyLoginname(loginname);
    }


    /*2.校验Email*/
    @RequestMapping("/verifyEmail")

    @ResponseBody
    public Boolean verifyEmail(String email) {
        return userService.verifyEmail(email);
    }

    /*查看用户信息*/
    @RequestMapping("/info")
    public String userInfo(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            User u = userService.getUserByUid(user.getUid());
            model.addAttribute("user", u);
        }
        return "jsps/user/info";
    }

    /*编辑个人资料页面*/
    @RequestMapping("/editInfo")
    public String editInfoPage(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            User u = userService.getUserByUid(user.getUid());
            model.addAttribute("user", u);
        }
        return "jsps/user/editInfo";
    }

    /*修改用户信息*/
    @RequestMapping("/updateInfo")
    public String updateUserInfo(User user, HttpSession session, Model model) {
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser != null) {
            user.setUid(sessionUser.getUid());
            boolean success = userService.updateUserInfo(user);
            if (success) {
                // 更新session中的用户信息
                User updatedUser = userService.getUserByUid(user.getUid());
                session.setAttribute("user", updatedUser);
                model.addAttribute("code", "success");
                model.addAttribute("msg", "用户信息更新成功！");
            } else {
                model.addAttribute("code", "error");
                model.addAttribute("msg", "用户信息更新失败！");
            }
        }
        return "jsps/msg";
    }

    /*修改密码页面*/
    @RequestMapping("/password")
    public String passwordPage() {
        return "jsps/user/password";
    }

    /*修改密码*/
    @RequestMapping("/updatePassword")
    public String updatePassword(String oldPassword, String newPassword, String confirmPassword, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user != null) {
            // 验证密码格式
            if (!PasswordHelper.isValidPassword(newPassword)) {
                model.addAttribute("code", "error");
                model.addAttribute("msg", PasswordHelper.getPasswordFormatHint());
                return "jsps/msg";
            }

            // 验证确认密码
            if (!newPassword.equals(confirmPassword)) {
                model.addAttribute("code", "error");
                model.addAttribute("msg", "两次输入的密码不一致！");
                return "jsps/msg";
            }

            // 验证旧密码
            User tempUser = new User();
            tempUser.setLoginname(user.getLoginname());
            tempUser.setLoginpass(oldPassword);
            User loginUser = userService.login(tempUser);
            if (loginUser != null) {
                // 旧密码正确，可以修改
                boolean success = userService.updateUserPassword(user.getUid(), newPassword);
                if (success) {
                    model.addAttribute("code", "success");
                    model.addAttribute("msg", "密码修改成功，请重新登录！");
                    session.invalidate(); // 密码修改成功后注销登录
                } else {
                    model.addAttribute("code", "error");
                    model.addAttribute("msg", "密码修改失败！");
                }
            } else {
                model.addAttribute("code", "error");
                model.addAttribute("msg", "原密码错误！");
            }
        }
        return "jsps/msg";
    }

    /*上传用户头像*/
    @RequestMapping("/uploadAvatar")
    public String uploadAvatar(@RequestParam("avatarFile") MultipartFile avatarFile, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            model.addAttribute("code", "error");
            model.addAttribute("msg", "请先登录！");
            return "jsps/msg";
        }

        try {
            // 检查文件是否为空
            if (avatarFile.isEmpty()) {
                model.addAttribute("code", "error");
                model.addAttribute("msg", "请选择要上传的头像！");
                return "jsps/msg";
            }

            // 获取服务器的真实路径
            String realPath = session.getServletContext().getRealPath("/upload/avatar/");
            // 创建目录（如果不存在）
            File dir = new File(realPath);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            // 生成唯一文件名
            String originalFilename = avatarFile.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            String newFilename = UUID.randomUUID().toString() + extension;

            // 构建文件保存路径
            String savePath = realPath + newFilename;
            String avatarPath = "/upload/avatar/" + newFilename;

            // 保存文件
            avatarFile.transferTo(new File(savePath));

            // 更新用户头像路径
            boolean success = userService.updateUserAvatar(user.getUid(), avatarPath);
            if (success) {
                // 更新session中的用户信息
                User updatedUser = userService.getUserByUid(user.getUid());
                session.setAttribute("user", updatedUser);
                model.addAttribute("code", "success");
                model.addAttribute("msg", "头像上传成功！");
            } else {
                model.addAttribute("code", "error");
                model.addAttribute("msg", "头像上传失败！");
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("code", "error");
            model.addAttribute("msg", "头像上传出错：" + e.getMessage());
        }

        return "jsps/msg";
    }

    /*忘记密码页面*/
    @RequestMapping("/forgotPassword")
    public String forgotPassword() {
        return "jsps/user/forgotPassword";
    }

    /*发送重置密码邮件*/
    @RequestMapping("/sendResetEmail")
    public String sendResetEmail(String email, Model model) {
        try {
            boolean success = userService.sendResetPasswordEmail(email);
            if (success) {
                model.addAttribute("code", "success");
                model.addAttribute("msg", "重置密码邮件已发送，请查收邮箱并点击链接重置密码（有效期30分钟）");
            } else {
                model.addAttribute("code", "error");
                model.addAttribute("msg", "该邮箱未注册或发送邮件失败，请检查邮箱地址");
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("code", "error");
            model.addAttribute("msg", "发送邮件失败：" + e.getMessage());
        }
        return "jsps/msg";
    }

    /*重置密码页面*/
    @RequestMapping("/resetPassword")
    public String resetPassword(String token, Model model) {
        // 验证token是否有效
        boolean isValid = userService.validateResetToken(token);
        if (isValid) {
            model.addAttribute("token", token);
            return "jsps/user/resetPassword";
        } else {
            model.addAttribute("code", "error");
            model.addAttribute("msg", "重置链接无效或已过期，请重新获取");
            return "jsps/msg";
        }
    }

    /*执行密码重置*/
    @RequestMapping("/doResetPassword")
    public String doResetPassword(String token, String verificationCode, String newPassword, String confirmPassword, Model model) {
        // 验证密码格式
        if (!PasswordHelper.isValidPassword(newPassword)) {
            model.addAttribute("code", "error");
            model.addAttribute("msg", PasswordHelper.getPasswordFormatHint());
            return "jsps/msg";
        }

        // 验证确认密码
        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("code", "error");
            model.addAttribute("msg", "两次输入的密码不一致！");
            return "jsps/msg";
        }

        // 执行密码重置
        try {
            boolean success = userService.resetPassword(token, verificationCode, newPassword);
            if (success) {
                model.addAttribute("code", "success");
                model.addAttribute("msg", "密码重置成功，请使用新密码登录");
            } else {
                model.addAttribute("code", "error");
                model.addAttribute("msg", "验证码错误或重置链接已过期，请重新获取");
            }
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("code", "error");
            model.addAttribute("msg", "密码重置失败：" + e.getMessage());
        }
        return "jsps/msg";
    }
}















