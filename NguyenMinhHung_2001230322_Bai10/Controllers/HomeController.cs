using NguyenMinhHung_2001230322_Bai10.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace NguyenMinhHung_2001230322_Bai10.Controllers
{
    public class HomeController : Controller
    {
        QLBanSachEntities db = new QLBanSachEntities();

        // danh sách sản phẩm 
        public ActionResult Index(string q = "")
        {
            var sp = db.tbl_SanPham.AsQueryable();   
            if (!string.IsNullOrWhiteSpace(q))
                sp = sp.Where(x => x.TenSP.Contains(q));
            return View(sp.ToList());
        }

        //  Thêm vào giỏ (Session)
        public ActionResult ChonMua(int id)
        {
            var gh = (GioHang)Session["gh"] ?? new GioHang();
            gh.Them(id);
            Session["gh"] = gh;
            return RedirectToAction("Index");
        }

        //  Xem/Xoá giỏ 
        public ActionResult XemGioHang() => View((GioHang)(Session["gh"] ?? new GioHang()));
        public ActionResult Xoa(int id) { var gh = (GioHang)Session["gh"] ?? new GioHang(); gh.Xoa(id); Session["gh"] = gh; return RedirectToAction("XemGioHang"); }
        public ActionResult XoaToanBo() { var gh = (GioHang)Session["gh"] ?? new GioHang(); gh.XoaToanBo(); Session["gh"] = gh; return RedirectToAction("XemGioHang"); }

        // Đăng nhập/Đăng xuất 
        public ActionResult DangNhap() => View();

        [HttpPost]
        public ActionResult DangNhap(string txtName, string txtPass)
        {
            var kh = db.tbl_KhachHang.FirstOrDefault(k => k.TenKH == txtName && k.MatKhau == txtPass);
            if (kh != null) { Session["kh"] = kh; return RedirectToAction("Index"); }
            ViewBag.err = "Sai tên hoặc mật khẩu";
            return View();
        }

        public ActionResult DangXuat() { Session["kh"] = null; return RedirectToAction("Index"); }

        //  Xác nhận & tạo đơn đặt hàng 
        [HttpGet]
        public ActionResult TaoDonDatHang()
        {
            if (Session["kh"] == null) return RedirectToAction("DangNhap");
            return View((GioHang)(Session["gh"] ?? new GioHang()));
        }

        [HttpPost]
        public ActionResult TaoDonDatHang(DateTime txtDate)
        {
            if (Session["kh"] == null) return RedirectToAction("DangNhap");
            var kh = (tbl_KhachHang)Session["kh"];
            var gh = (GioHang)(Session["gh"] ?? new GioHang());
            if (!gh.lst.Any()) return RedirectToAction("Index");

            var hd = new tbl_HoaDon { NgayHoaDon = DateTime.Now, NgayGiao = txtDate, MaKH = kh.MaKhachHang };
            db.tbl_HoaDon.Add(hd);
            db.SaveChanges();

            foreach (var it in gh.lst)
                db.tbl_ChiTiet.Add(new tbl_ChiTiet  { MaHoaDon = hd.MaHoaDon, MaSP = it.iMaSach, SoLuong = it.iSoLuong, DonGia = it.dDonGia });

            db.SaveChanges();
            gh.XoaToanBo(); Session["gh"] = gh;
            return View("ThongBao");
        }
    }
}
