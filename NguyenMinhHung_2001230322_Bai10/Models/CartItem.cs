using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NguyenMinhHung_2001230322_Bai10.Models
{
    public class CartItem
    {
        public int iMaSach { get; set; }
        public string sTenSach { get; set; }
        public string sAnhBia { get; set; }
        public decimal dDonGia { get; set; }
        public int iSoLuong { get; set; }
        public decimal ThanhTien => dDonGia * iSoLuong;

        private static QLBanSachEntities db = new QLBanSachEntities();
        public CartItem(int maSach)
        {
            var sp = db.tbl_SanPham.SingleOrDefault(x => x.MaSanPham == maSach);
            if (sp != null) { iMaSach = sp.MaSanPham; sTenSach = sp.TenSP; sAnhBia = sp.HinhAnh; dDonGia = sp.DonGia; iSoLuong = 1; }
        }
    }
}