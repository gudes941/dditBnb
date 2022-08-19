package kr.or.ddit.bnb.prod.vo;

import java.util.List;

public class ProdVO {
	private String prod_id    ;
	private String prod_type  ;
	private String prod_part  ;
	private String city_id    ;
	private String prod_add1  ;
	private String prod_add2  ;
	private String prod_name  ;
	private String prod_des   ;
	private int prod_per   ;
	private String prod_date  ;
	private int prod_price ;
	private String mem_id    ;
	private String host_des;
	private String host_id;
	private String host_date;
	
	
	
	
	
	
	public final String getHost_date() {
		return host_date;
	}
	public final void setHost_date(String host_date) {
		this.host_date = host_date;
	}
	public final String getMem_id() {
		return mem_id;
	}
	public final void setMem_id(String mem_id) {
		this.mem_id = mem_id;
	}
	public final String getHost_des() {
		return host_des;
	}
	public final void setHost_des(String host_des) {
		this.host_des = host_des;
	}
	private List<String> link    ;
	private double star;
	private List<ConvenVO> convenVo;
	
	
	public List<ConvenVO> getConvenVo() {
		return convenVo;
	}
	public void setConvenVo(List<ConvenVO> convenVo) {
		this.convenVo = convenVo;
	}
	public double getStar() {
		return star;
	}
	public void setStar(double star) {
		this.star = star;
	}
	public List<String> getLink() {
		return link;
	}
	public void setLink(List<String> link) {
		this.link = link;
	}
	
	public String getProd_id() {
		return prod_id;
	}
	public void setProd_id(String prod_id) {
		this.prod_id = prod_id;
	}
	public String getProd_type() {
		return prod_type;
	}
	public void setProd_type(String prod_type) {
		this.prod_type = prod_type;
	}
	public String getProd_part() {
		return prod_part;
	}
	public void setProd_part(String prod_part) {
		this.prod_part = prod_part;
	}
	public String getCity_id() {
		return city_id;
	}
	public void setCity_id(String city_id) {
		this.city_id = city_id;
	}
	public String getProd_add1() {
		return prod_add1;
	}
	public void setProd_add1(String prod_add1) {
		this.prod_add1 = prod_add1;
	}
	public String getProd_add2() {
		return prod_add2;
	}
	public void setProd_add2(String prod_add2) {
		this.prod_add2 = prod_add2;
	}
	public String getProd_name() {
		return prod_name;
	}
	public void setProd_name(String prod_name) {
		this.prod_name = prod_name;
	}
	public String getProd_des() {
		return prod_des;
	}
	public void setProd_des(String prod_des) {
		this.prod_des = prod_des;
	}
	public int getProd_per() {
		return prod_per;
	}
	public void setProd_per(int prod_per) {
		this.prod_per = prod_per;
	}
	public String getProd_date() {
		return prod_date;
	}
	public void setProd_date(String prod_date) {
		this.prod_date = prod_date;
	}
	public int getProd_price() {
		return prod_price;
	}
	public void setProd_price(int prod_price) {
		this.prod_price = prod_price;
	}
	public String getHost_id() {
		return host_id;
	}
	public void setHost_id(String host_id) {
		this.host_id = host_id;
	}
	@Override
	public String toString() {
		return "ProdVO [prod_id=" + prod_id + ", prod_type=" + prod_type + ", prod_part=" + prod_part + ", city_id="
				+ city_id + ", prod_add1=" + prod_add1 + ", prod_add2=" + prod_add2 + ", prod_name=" + prod_name
				+ ", prod_des=" + prod_des + ", prod_per=" + prod_per + ", prod_date=" + prod_date + ", prod_price="
				+ prod_price + ", host_id=" + host_id + ", link=" + link + ", star=" + star + ", convenVo=" + convenVo
				+ "]";
	}
	
	
	
	
	
	
	
	
	
}
