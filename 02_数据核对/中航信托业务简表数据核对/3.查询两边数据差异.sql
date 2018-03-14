--������ģ����
select t1.c_proj_code,
       t1.f_cxgm as ��������ģ,
       t2.c_grain,
       t2.c_proj_name,
       t2.f_value as BI������ģ,
       nvl(t1.f_cxgm,0) - nvl(t2.f_value,0) as ��ֵ
  from temp_20180222_01 t1
  full outer join temp_20180222_02 t2
    on t1.c_proj_code = t2.c_grain
 where nvl(t1.f_cxgm,0) <> nvl(t2.f_value,0);

--�ƻ��������
select t1.c_proj_code,
       t1.f_xtsr as ����ͬ����,
       t1.f_xtbc as ������б���,
       t1.f_xtcgf as ���ƹ˷�,
       t2.c_proj_code,
       t2.c_proj_name,
       t2.f_xtsr as BI��ͬ����,
       t2.f_xtbc as BI���б���,
       t2.f_xtcgf as BI���вƹ˷�,
       t1.f_xtsr - t2.f_xtsr as ��ֵ
  from temp_20180222_03 t1
  full outer join temp_20180222_04 t2
    on t1.c_proj_code = t2.c_proj_code
 where t1.f_xtsr <> t2.f_xtsr;
 
--���������ģ����
select t1.c_proj_code,
       t1.f_qsgm as ��������ģ,
       t2.c_proj_code,
       t2.c_proj_name,
       t2.f_qsgm as BI�����ģ,
       t1.f_qsgm - t2.f_qsgm as ��ֵ
  from temp_20180222_05 t1
  full outer join temp_20180222_06 t2
    on t1.c_proj_code = t2.c_proj_code
 where t1.f_qsgm <> t2.f_qsgm;

--����������Ŀ��������
select t1.c_proj_code,
       t2.c_proj_code  
       from temp_20180222_07 t1
  full outer join temp_20180222_08 t2
    on replace(t1.c_proj_code,'
','') = t2.c_proj_code
 where t1.c_proj_code is null or t2.c_proj_code is null;


--����������ģ����
select t1.c_proj_code,
       t1.f_xzgm as ���������ģ,
       t2.c_proj_code,
       t2.c_proj_name,
       t2.f_xzgm as BI������ģ,
       nvl(t1.f_xzgm,0) - nvl(t2.f_xzgm,0) as ��ֵ
  from temp_20180222_09 t1
  full outer join temp_20180222_10 t2
    on replace(t1.c_proj_code,'
','') = t2.c_proj_code
 where nvl(t1.f_xzgm,0) <> nvl(t2.f_xzgm,0);
