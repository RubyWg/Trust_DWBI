--��ĿҪ��
select case when t.d_begdate is null then '��������Ϊ��'
            when (t.c_projphase = '99' and t.d_enddate is null) then '��Ŀ�׶��Ѿ���ֹ����ֹ����δά��'
              when (t.d_enddate is null and t.c_projphase <> '99' ) then '��Ŀ����ֹ���׶β�Ϊ99'
            when (nvl(t.d_enddate,to_date('20991231','yyyymmdd')) < t.d_begdate) then '��������С�ڳ�������'
                  end as �쳣,
       t.c_projcode as ��Ŀ����,
       t.c_fullname as ��Ŀ����,
       t.c_shortname as ��Ŀ���,
       t.d_begdate as ��ʼ����,
       t.d_predue as  Ԥ�Ƶ�������,
       t.d_enddate as ��������,
       t.c_dptid as ����ID,
       t.c_tmanager as ���о���,
       t.c_projstatus as ��Ŀ״̬,
       t.c_projphase as ��Ŀ�׶�,
       t.l_busiscope as ҵ��Χ,
       t.l_singleset as ��һ����,
       t.c_trustclass as ��������,
       t.l_functype as ���ܷ���,
       t.l_runmode as ���з�ʽ,
       t.l_managemode as ����ʽ,
       t.c_capuseway as �ʽ����÷�ʽ,
       t.l_industry as Ͷ����ҵ,
       t.c_investdir as ���÷���,
       t.c_coopbit as ������ʽ
  from pm_projectinfo t 
  order by t.c_projcode;
  
--����Ҫ��
select a.c_orgid as ����ID,
       a.c_orgcode as ���ű���,
       a.c_orgname as ��������,
       a.c_parentid as ��������ID,
       a.l_level as �㼶,
       a.l_leaf as �Ƿ�Ҷ�ڵ�,
       a.c_orgcalss as ��֯����,
       a.c_busiclass as ҵ�����,
       a.l_sort as �����
  from hr_org a
 order by a.l_sort;
 
--Ա��Ҫ��
select a.c_userid, a.c_usercode, a.c_username, b.c_orgname
  from hr_user a, hr_org b
 where a.c_orgid = b.c_orgid(+);
 
--��ƷҪ��
select a.c_fundcode as ��Ʒ����,
       a.c_fundname as ��Ʒ����,
       a.c_projcode as ��Ŀ����,
       a.d_setupdate as ��������,
       a.d_enddate as ��ֹ����,
       a.l_strucflag as �ṹ����ʶ,
       a.l_beneftype as ����Ȩ����
  from ta_fundinfo a;

--��Ʒ������
select * from TA_FUNDAGENCY;

--���к�ͬҪ��
select * from ta_pact;
select * from ta_order;
select * from ta_fundagency t where t.c_agencyno = '008008';

--Ͷ�ʺ�ͬҪ��
select/* distinct t.c_btype*/* from am_pact t where t.l_pactprop = 2 and t.l_ifflag = 2; --and t.c_btype = '1';
select * from am_busiflag t where t.c_functype = '8' and  t.l_busiid = 22151;
select * from am_order;
select * from am_guarantee;
select * from am_pactrate;
select * from am_pactvary;
select * from am_pactiou;
select * from cm_rival;
select * from cm_rivalholder;
