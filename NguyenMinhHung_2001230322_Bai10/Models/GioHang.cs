using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace NguyenMinhHung_2001230322_Bai10.Models
{
    public class GioHang
    {
        public List<CartItem> lst { get; set; } = new List<CartItem>();
        public int SoMatHang() => lst.Count;
        public int TongSLHang() => lst.Sum(n => n.iSoLuong);
        public decimal TongThanhTien() => lst.Sum(n => n.ThanhTien);
        public int Them(int maSach) { var sp = lst.Find(n => n.iMaSach == maSach); if (sp == null) lst.Add(new CartItem(maSach)); else sp.iSoLuong++; return 1; }
        public void Xoa(int maSach) => lst.RemoveAll(n => n.iMaSach == maSach);
        public void XoaToanBo() => lst.Clear();
    }
}