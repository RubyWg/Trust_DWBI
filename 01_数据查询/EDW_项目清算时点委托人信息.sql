--���ű����ڲ�ѯ��Ŀ������ʱ���Ӧ��ί������Ϣ
--zhangtf10208
--20170106

--ɾ����ʱ��
drop table temp_20170106;

--������ʱ��
create table temp_20170106 as 
select c.l_proj_Id,
       c.c_proj_code,
       i.c_proj_type_n,
       case
         when g.l_fdsrc_type = 2 then
          '����'
         when g.l_fdsrc_type = 6 then
          '���'
         else
          '����'
       end as c_fdsrc_type,
       g.c_fdsrc_name,
       h.c_inst_name,
       f.c_cust_name,
       f.c_cust_tytpe_n,
       a.f_scale
  from tt_sr_scale_flow_d   a,
       dim_sr_stage         b,
       dim_pb_project_basic c,
       dim_tc_contract      d,
       dim_ca_customer      f,
       dim_tc_fund_source   g,
       dim_pb_institution   h,
       dim_pb_project_biz   i
 where a.l_scatype_id = 1301
   and a.l_stage_id = b.l_stage_id
   and a.l_proj_id = c.l_proj_id
   and c.l_proj_id = i.l_proj_id
   and b.l_stage_id = d.l_stage_Id
   and d.l_settler_id = f.l_cust_id(+)
   and d.L_fdsrc_id = g.l_fdsrc_id(+)
   and d.l_fdsrc_inst_id = h.l_inst_id(+)
   and c.l_expiry_date >= 20160101
   and c.l_expiry_date is not null
      --and c.c_proj_name like '%�۸�257%'
   and exists (select 1
          from tt_tc_scale_flow_d e
         where d.l_cont_id = e.l_cont_id
           and a.l_change_date = e.l_change_date
           and e.l_scatype_id = 2)
   and b.l_effective_flag = 1
 order by c.c_proj_code,
          g.c_fdsrc_name,
          h.c_inst_name,
          f.c_cust_name,
          f.c_cust_tytpe_n;

--������Ŀ����ʱί���˸���������
select s.c_proj_code,
       nvl(decode(s.c_cust_tytpe_n, '����', s.l_count, null), 0),
       nvl(decode(s.c_cust_tytpe_n, '����', s.l_count, null), 0)
  from (select t.c_proj_code, t.c_cust_tytpe_n, count(*) as l_count
          from temp_20170106 t --where t.c_proj_code = 'C136'
         group by t.c_proj_code, t.c_cust_tytpe_n
         order by t.c_proj_code, t.c_cust_tytpe_n) s;

--��һ��Ŀ���ʽ���Դ
select t.c_proj_code, t.c_fdsrc_type, t.c_fdsrc_name
  from temp_20170106 t
 where t.c_proj_type_n = '��һ';

--��Ŀ���ʽ���Դ����
select t.c_proj_code,
       listagg(t.c_inst_name, ',') within group(order by t.c_proj_code)
  from temp_20170106 t
 group by t.c_proj_code;

--��Ŀ�Ƿ��������Ȩת��
select distinct s.c_proj_code
  from temp_20170106 s
 where exists (select 1
          from tt_tc_scale_flow_d t, dim_tc_contract t1
         where t.l_cont_id = t1.l_cont_id
           and t.l_scatype_id in (9, 10)
           and s.l_proj_id = t1.l_proj_id);
           
--��Ŀί������ϸ
select t1.c_proj_code,
       listagg(t1.c_cust_name, ',') within group(order by t1.c_proj_code)
  from (select distinct t.c_proj_code,
                        t.c_fdsrc_name,
                        case
                          when t.c_fdsrc_name = '��������' then
                           '����'
                          else
                           t.c_cust_name
                        end as c_cust_name
          from temp_20170106 t) t1
 group by t1.c_proj_code;

--��Ŀ�ʽ���Դ��ϸ
select t1.c_proj_code,
       listagg(t1.c_fdsrc_name, ',') within group(order by t1.c_proj_code)
  from (select distinct t.c_proj_code, t.c_fdsrc_name from temp_20170106 t) t1
 group by t1.c_proj_code;
