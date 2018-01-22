--��Ʒ��Ϣ
select a.c_prod_code     as ��Ʒ����,
       a.c_prod_name     as ��Ʒ����,
       a.c_proj_code     as ��Ŀ����,
       b.c_proj_name     as ��Ŀ����,
       a.c_prod_status   as ��Ʒ״̬,
       a.c_prod_status_n as ��Ʒ״̬,
       a.d_setup         as ��������,
       a.d_expiry        as ��ֹ����,
       a.l_struct_flag   as �Ƿ�ṹ��,
       a.c_struct_type   as ����ṹ����,
       a.c_struct_type_n as ����ṹ����
  from tde_product a, tde_project b
 where a.c_proj_code = b.c_proj_code(+)
 order by a.d_setup;

--��Ŀ�Ͳ�Ʒ��������
select s.c_projcode  as ��Ŀ����,
       s.c_fullname  as ��Ŀ����,
       s.d_begdate   as ��Ŀ��ʼ����,
       s.d_enddate   as ��Ŀ��������,
       t.c_fundcode  as ��Ʒ����,
       t.c_fundname  as ��Ʒ����,
       t.d_issuedate as ��Ʒ��������,
       t.d_setupdate as ��Ʒ��������,
       t.d_enddate   as ��Ʒ��ֹ����,
       t.d_liqudate  as ��Ʒ��������
  from ta_fundinfo t, pm_projectinfo s
 where t.c_projcode = s.c_projcode
   --and t.d_setupdate is null
   and exists (select 1
          from bulu_amfareplan r1
         where t.c_fundcode = r1.vc_product_id);
		 
--��Ŀ����ֹ����Ʒδ����������ά����������,���޴�����ģ
with temp_scale as
 (select t.c_fundcode,
         sum(case
               when t.c_busiflag = '03' then
                t.f_tshares * -1
               else
                t.f_tshares
             end) as f_scale
    from ta_order t
   where t.c_busiflag in ('50', '02', '03')
   group by t.c_fundcode
  having sum(case
    when t.c_busiflag = '03' then
     t.f_tshares * -1
    else
     t.f_tshares
  end) = 0)
select *
  from ta_fundinfo t, temp_scale
 where t.c_status <> '6'
   and t.c_fundcode = temp_scale.c_fundcode
   and nvl(t.d_enddate, to_date('20991231', 'yyyymmdd')) <=
       to_date('20160930', 'yyyymmdd')
   and exists (select 1
          from pm_projectinfo s
         where t.c_projcode = s.c_projcode
           and s.c_projphase = '99');
		   
--��Ʒ����ֹ�����д�����ģ
with temp_scale as
 (select t.c_fundcode,
         sum(case
               when t.c_busiflag = '03' then
                t.f_tshares * -1
               else
                t.f_tshares
             end) as f_scale
    from ta_order t
   where t.c_busiflag in ('50', '02', '03')
   group by t.c_fundcode
  having sum(case
    when t.c_busiflag = '03' then
     t.f_tshares * -1
    else
     t.f_tshares
  end) <> 0)
select c.c_projcode   as ��Ŀ����,
       c.c_fullname   as ��Ŀ����,
       c.c_projstatus as ��Ŀ״̬,
       c.c_projphase  as ��Ŀ�׶�,
       a.c_fundcode   as ��Ʒ����,
       a.c_fundname   as ��Ʒ����,
       a.d_issuedate  as ��Ʒ��������,
       a.d_enddate    as ��Ʒ��ֹ����,
       b.f_scale      as ��ģ���
  from ta_fundinfo a, pm_projectinfo c, temp_scale b
 where a.c_projcode = c.c_projcode
      and nvl(a.d_enddate, to_date('20991231', 'yyyymmdd')) <=
      to_date('20151231', 'yyyymmdd')
   and a.c_status = '6'
   and a.c_fundcode = b.c_fundcode
 order by c.d_begdate;

