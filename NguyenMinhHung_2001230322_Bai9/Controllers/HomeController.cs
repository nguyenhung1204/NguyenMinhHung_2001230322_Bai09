using NguyenMinhHung_2001230322_Bai9.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace NguyenMinhHung_2001230322_Bai9.Controllers
{
    public class HomeController : Controller
    {
        QLSACH db = new QLSACH();
        public ActionResult Index()
        {
            ViewBag.ListChuDe = db.CHUDEs.ToList();
            ViewBag.ListNXB = db.NHAXUATBANs.ToList();
            //take lấy 5 dòng đầu tiên 
            //orderbysescending sắp xếp giảm dần theo ngày cập nhật 
            List<SACH> dsSach = db.SACHes.OrderByDescending(x => x.NgayCapNhat).Take(10).ToList();
            return View(dsSach);
        }

        public ActionResult Details(string id)
        {
            ViewBag.ListChuDe = db.CHUDEs.ToList();
            ViewBag.ListNXB = db.NHAXUATBANs.ToList();
            id = id.Trim(); //LOẠI BỎ KHOẢNG TRẮNG DƯ
            //Firstondefault tìm kiếm them chữ cái đầu 
            var Details_sach = db.SACHes.FirstOrDefault(m => m.MaSach == id);

            if (Details_sach == null)
                return HttpNotFound();
            // truy vấn lấy danh sách tên tác giả từ mã sách 
            var tacgialist = (from tg in db.TACGIAs
                              join tg_sach in db.THAMGIAs on tg.MaTacGia equals tg_sach.MaTacGia
                              where tg_sach.MaSach == id
                              select tg.TenTacGia).ToList();
            // Gửi danh sách tên tác giả sang View
            ViewBag.ListTacGia = tacgialist;

            //chọn các sản phẩm có cùng tác giả

            var SachCungChuDe = db.SACHes.Where(s => s.MaChuDe == Details_sach.MaChuDe && s.MaSach != Details_sach.MaSach).Take(4).ToList();
            ViewBag.sachchungchude = SachCungChuDe;
            //chọn các sản phẩm có cùng nhà xuất

            var SachCungNXB = db.SACHes.Where(s => s.MaNXB == Details_sach.MaNXB && s.MaSach != Details_sach.MaSach).Take(4).ToList();

            ViewBag.sachcungNXB = SachCungNXB;


            return View(Details_sach);

        }
        public ActionResult SachTheoChuDe(string MaCD)
        {
            ViewBag.ListChuDe = db.CHUDEs.ToList();
            ViewBag.ListNXB = db.NHAXUATBANs.ToList();

            // Lấy đối tượng chủ đề
            var TenChuDe = db.CHUDEs.FirstOrDefault(m => m.MaChuDe == MaCD);

            // Gán tên chủ đề (chuỗi) vào ViewBag
            ViewBag.TenChuDe = TenChuDe != null ? TenChuDe.TenChuDe : "Không xác định";

            // Lấy danh sách sách thuộc chủ đề, sắp xếp tăng dần theo giá
            var ChuDe = db.SACHes.Where(s => s.MaChuDe == MaCD).OrderBy(s => s.GiaBan).ToList();

            return View(ChuDe);


        }
        public ActionResult SachTheoNXB(string MANXB)
        {
            ViewBag.ListChuDe = db.CHUDEs.ToList();
            ViewBag.ListNXB = db.NHAXUATBANs.ToList();

            //Lấy tên nhà xuất bản
            var TenNXB = db.NHAXUATBANs.FirstOrDefault(X => X.MaNXB == MANXB);

            //gán tên chủ đề vào chuỗi viewbag

            ViewBag.TenNXB = TenNXB != null ? TenNXB.TenNXB : "Không Xác định";

            //Lấy danh sách nhà xuất bản và sấp xếp tăng dần theo giá 

            var NXB = db.SACHes.Where(s => s.MaNXB == MANXB).OrderBy(s => s.GiaBan).ToList();


            return View(NXB);

        }

        public ActionResult Search(string search)
        {
            ViewBag.ListChuDe = db.CHUDEs.ToList();
            ViewBag.ListNXB = db.NHAXUATBANs.ToList();
            if (string.IsNullOrWhiteSpace(search))
            {
                List<SACH> dsSach = db.SACHes.OrderByDescending(x => x.NgayCapNhat).Take(10).ToList();
                return View("Index", dsSach);
            }
            else
            {
                SACH s = new SACH();
                List<SACH> lstSach = db.SACHes.Where(item => item.TenSach.Contains(search)).ToList();
                return View("Index", lstSach);
            }
        }



    }
}
