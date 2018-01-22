--1����Ч���ڴ���ʧЧ����
select * from thr_dividescheme t where t.d_bdate > t.d_edate;

--2����һ���ֳɱ����Ŀ�ʼ��ݴ���ʵ��ҵ���������
select s1.d_plandate, t1.*
  from (select row_number() over(partition by t.c_stagescode order by t.d_bdate) as l_rn,
               t.*
          from thr_dividescheme t /*where t.c_stagescode = 'E666-2'*/) t1,
       (select s.c_stagescode, min(s.d_plandate) as d_plandate
          from tam_fareplan s
         where s.l_fareflag > 0
         group by s.c_stagescode) s1
 where t1.c_stagescode = s1.c_stagescode
   and to_char(t1.d_bdate,'yyyy') > to_char(s1.d_plandate,'yyyy')
   and t1.l_rn = 1;
   
--3��Ա���Ŀ�����Ч���ڣ��벿�ŵĿ�����Ч���ڲ���ͬһ��
select t1.c_stagescode,t1.d_bdate as ���ſ�������,s1.d_bdate as Ա����������
  from (select row_number() over(partition by t.c_stagescode order by t.d_bdate) as l_rn,
               t.*
          from thr_dividescheme t
         where t.c_Level = 'BM' /*and t.c_stagescode = 'F014-2'*/) t1,
       (select row_number() over(partition by s.c_stagescode order by s.d_bdate) as l_rn,
               s.*
          from thr_dividescheme s
         where s.c_Level = 'YG' /*and s.c_stagescode = 'F014-2'*/) s1
 where t1.c_stagescode = s1.c_stagescode
   and t1.l_rn = 1
   and s1.l_rn = 1
   and to_char(t1.d_bdate, 'yyyy') <> to_char(s1.d_bdate, 'yyyy');
   
--4���ڴβ��ֵܷ�Ա�����ƹ˷��ֵܷ�Ա��
select t1.c_projectcode,t3.d_setup,t3.c_projphase
  from (select distinct a.c_projectcode
          from thr_dividescheme a
         where a.c_stagescode is null
           and a.c_level = 'YG') t1,
       (select distinct a.c_projectcode
          from thr_dividescheme a
         where a.c_stagescode is not null
           and a.c_level = 'YG') t2,
           tprojectinfo t3
 where t1.c_projectcode = t2.c_projectcode(+) and t2.c_projectcode is null and t1.c_projectcode = t3.c_projectcode;

--5���ֳɱ������ݴ����ظ�--���Ŀǰ����Ӱ�죬BI�����
select a.c_projectcode,
       a.c_stagescode,
       a.l_divideway,
       a.d_bdate,
       a.d_edate,
       a.l_ischeck,
       a.c_level,
       a.c_object
  from thr_dividescheme a where a.d_edate > to_date('20151231','yyyymmdd') or a.d_edate is null
 group by a.c_projectcode,
          a.c_stagescode,
          a.l_divideway,
          a.d_bdate,
          a.d_edate,
          a.l_ischeck,
          a.c_level,
          a.c_object
having count(*) > 1;

--6.�����Ѿ�ʧЧ���ֳɷ����������ڻ���Ϊ��
select *
  from thr_dividescheme a
 where a.d_edate is null
   and a.c_level = 'BM'
   and a.d_bdate is not null
   and exists (select 1
          from tbd_org b
         where a.c_object = b.c_orgid
           and b.c_status <> '0');
           
--7.Ա���Ѿ�ʧЧ���ֳɷ����������ڻ���Ϊ��
select *
  from thr_dividescheme a
 where a.d_edate is null
   and a.c_level = 'YG'
   and a.d_bdate is not null
   and exists (select 1
          from tbd_user b
         where a.c_object = b.c_userid
           and b.c_status <> '0');
           
--8.Ա���ֳɺ�������ֳ�ǰ��һ�µģ�
select * from v_temp_stage_sr a full outer join v_temp_emp_divide b on a.c_grain = b.c_grain where nvl(a.f_value,0) <> nvl(b.f_fcsr,0);

--9.���ŷֳɺ�������ֳ�ǰ��һ�µ�
select * from v_temp_stage_sr a full outer join v_temp_dept_divide b on a.c_grain = b.c_stage_code where nvl(a.f_value,0) = nvl(b.f_fcsr,0);


