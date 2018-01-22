--�ͻ��ṹ����--���ͻ����Ϳͻ�����
select b.c_cust_cate_n, b.c_cust_type_n, count(a.f_count_agg)
  from tt_ca_count_cust_m a, dim_ca_customer b, dim_ca_behavior c
 where a.l_cust_id = b.l_cust_id
   and a.l_beha_id = c.l_beha_id
   and c.c_beha_code = 'KH_XX_SS_CJ'
   and a.l_month_id = 201612
   and b.l_effective_flag = 1
 group by b.c_cust_cate_n, b.c_cust_type_n;

--��ʵ���˿ͻ���������
--�ɸ���dim_pb_individual�����Խ��е���
select d.l_age, count(1)
  from tt_ca_count_cust_m a,
       dim_ca_customer    b,
       dim_ca_behavior    c,
       dim_pb_individual  d
 where a.l_cust_id = b.l_cust_id
   and a.l_beha_id = c.l_beha_id
   and c.c_beha_code = 'KH_XX_SS_CJ'
   and a.l_month_id = 201612
   and b.l_effective_flag = 1
   and b.c_cust_type = '1'
   and b.c_cust_cate = 'A'
   and b.l_unique_id = d.l_indiv_id
 group by d.l_age; 
 
--��ʵ�����ͻ���������
--�ɸ���dim_pb_organization�����Խ��е���
select d.c_organ_type_n, count(1)
  from tt_ca_count_cust_m  a,
       dim_ca_customer     b,
       dim_ca_behavior     c,
       dim_pb_organization d
 where a.l_cust_id = b.l_cust_id
   and a.l_beha_id = c.l_beha_id
   and c.c_beha_code = 'KH_XX_SS_CJ'
   and a.l_month_id = 201612
   and b.l_effective_flag = 1
   and b.c_cust_type = '2'
   and b.c_cust_cate = 'A'
   and b.l_unique_id = d.l_organ_id
 group by d.c_organ_type_n;

 
--�ܿͻ���
select t.c_cust_type_n, count(*)
  from dim_ca_customer t
 where t.l_effective_flag = 1
   and t.c_cust_cate = 'A' --��ʵ�ͻ�
 group by t.c_cust_type_n;

--��Ա����
select count(*) from dim_ca_member t where t.l_effective_flag = 1;

--�������Ŷ�����ľ�����
select a.c_team_code, a.c_team_name, b.c_broker_code, b.c_broker_name
  from dim_ca_broker_team a, dim_ca_broker b
 where a.l_team_id = b.l_team_id
   and b.l_effective_flag = 1;

--�����Ŷ�
select b.c_area_name,
       b.c_name_abbr,
       b.l_local_flag,
       a.c_team_code,
       a.c_team_name,
       c.c_broker_code,
       c.c_broker_name
  from dim_ca_broker_team a, dim_pb_area b, dim_ca_broker c
 where a.l_area_id = b.l_area_id
   and a.l_team_id = c.l_team_id;

--����������ͻ�����
select a.c_broker_code, a.c_broker_name, count(*)
  from dim_ca_broker a, dim_ca_broker_cust b, dim_ca_customer c
 where a.l_broker_id = b.l_broker_id
   and b.l_cust_id = c.l_cust_id
   and b.c_rela_type = '0' --�ͻ�����
 group by a.c_broker_code, a.c_broker_name
 order by count(*) desc;

--�ͻ��ݶ����--���ͻ�����
--�ɸ�����ΪID���е���
select c.c_cust_type_n, sum(a.f_share_agg) / 100000000
  from tt_ca_share_cust_m a, dim_ca_behavior b, dim_ca_customer c
 where a.l_beha_id = b.l_beha_id
   and a.l_cust_id = c.l_cust_id
   and b.c_beha_code = 'KH_JY_CC' --�ͻ����׳ֲ�
   and a.l_month_id = 201612
   and c.c_cust_cate = 'A' --��ʵ�ͻ�
 group by c.c_cust_type_n;

--�ͻ������Ӧ�ͻ��ݶ����
--�ɸ�����ΪID���е���
select e.c_broker_name, sum(a.f_share_agg)
  from tt_ca_share_cust_m a,
       dim_ca_behavior    b,
       dim_ca_customer    c,
       dim_ca_broker_cust d,
       dim_ca_broker      e
 where a.l_beha_id = b.l_beha_id
   and a.l_cust_id = c.l_cust_id
   and c.l_cust_id = d.l_cust_id
   and d.l_primary_flag = 1
   and d.l_broker_id = e.l_broker_id
   and b.c_beha_code = 'KH_JY_CC'
   and a.l_month_id = 201612
 group by e.c_broker_name
 order by sum(a.f_share_agg) desc;
   
--�Ƹ����Ŷ�Ӧ�ͻ��ݶ����
--�ɸ�����ΪID���е���
select f.c_team_name, sum(a.f_share_agg)
  from tt_ca_share_cust_m a,
       dim_ca_behavior    b,
       dim_ca_customer    c,
       dim_ca_broker_cust d,
       dim_ca_broker      e,
       dim_ca_broker_team f
 where a.l_beha_id = b.l_beha_id
   and a.l_cust_id = c.l_cust_id
   and c.l_cust_id = d.l_cust_id
   and d.l_primary_flag = 1
   and d.l_broker_id = e.l_broker_id
   and e.l_team_id = f.l_team_id
   and b.c_beha_code = 'KH_JY_CC'
   and a.l_month_id = 201612
 group by f.c_team_name
 order by sum(a.f_share_agg) desc;

--�ͻ�����
select a.l_month_id,
       sum(a.f_count_eot) as ÿ�¿ͻ�������,
       sum(a.f_count_agg) as �ۼƿͻ���
  from tt_ca_count_cust_m a, dim_ca_behavior b
 where a.l_beha_id = b.l_beha_id
   and b.c_beha_code = 'KH_XX_SS_CJ'
 group by a.l_month_id order by a.l_month_id ;