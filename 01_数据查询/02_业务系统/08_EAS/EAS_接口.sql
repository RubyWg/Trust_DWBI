--��ƿ�Ŀ��
select t.c_id         as c_subid, --��Ŀid
       t.c_number     as c_subcode, --��Ŀ����
       t.c_name       as c_subname, --��Ŀ����
       t1.c_number    as l_class, --��Ŀ����
       0              as c_fundid, --����id
       t.f_dc         as l_baldir, --����
       t.f_level      as l_level, --��Ŀ����
       t.f_isleaf     as l_leaf, --�Ƿ���ϸ
       t.c_currencyid as c_cykind, --���ִ���
       t.c_parentid   as c_fsubcode --������Ŀ
  from ts_ea_accountview t, ts_ea_accounttype t1
 where t.c_accounttypeid = t1.c_id;

--��˾������Ŀ����Ŀ�ɸ�������
select t3.fname_l2, t2.fname_l2, t1.*
  from T_BD_AccountView t1, T_BD_ASSTACCOUNT t2, T_ORG_Company t3
 where t1.fcaa = t2.fid
   and t1.fcompanyid = t3.fid
   and t1.fnumber like '6001%'
   and t3.fname_l2 like '%����%';

--�����������
select t.fid, t.fasstaccountid, t1.fname_l2, t.fproviderid, t.fcostorgid,
       t2.fname_l2, t.fcontrolunitid, t.fgeneralassacttype6id, t3.fnumber,
       t3.fname_l2
  from T_BD_AssistantHG t, T_BD_ASSTACCOUNT t1, t_org_costcenter t2,
       t_bd_generalasstacttype t3
 where t.fasstaccountid = t1.fid
   and t.fcostorgid = t2.fid
   and t.fgeneralassacttype6id = t3.fid
   and t.fid = 'WuUAAAAG0UFBimy7';   

--ƾ֤��¼��--EAS
SELECT T.FID AS C_JOURID, --��¼ID
       T.FBILLID AS C_VOUCHERID, --ƾ֤ID
       0 AS C_FUNDID, --����ID
       T1.FBIZDATE AS D_BUSI, --ҵ������
       T1.FDESCRIPTION AS C_DIGEST, --ƾ֤ժҪ
       T.FSEQ AS L_ROWID, --��¼��
       T2.FNUMBER AS C_SUBCODE, --��Ŀ����
       T2.FNAME_L2 AS C_SUBNAME, --��Ŀ����
       T.FENTRYDC AS L_BALDIR, --����
       DECODE(T.FENTRYDC, 1, T.FLOCALAMOUNT, 0) AS F_DEBIT, --���ҽ跽
       DECODE(T.FENTRYDC, 0, T.FLOCALAMOUNT, 0) AS F_CREDIT, --���Ҵ���
       T4.FNUMBER AS C_CYKIND, --���ִ���
       NULL AS F_EXCH, --����
       T.FORIGINALAMOUNT AS F_FOREIGN, --��ҽ��
       T1.FBIZSTATUS AS L_STATE, --ƾ֤״̬
       T3.FPERIODYEAR AS L_YEAR, --������
       T3.FPERIODNUMBER AS L_MONTH, --����·�
       NULL AS C_COMBID --���ID
  FROM T_GL_VOUCHERENTRY T,
       T_GL_VOUCHER      T1,
       T_BD_ACCOUNTVIEW  T2,
       T_BD_PERIOD       T3,
       T_BD_CURRENCY     T4,
       T_ORG_COMPANY     T5
 WHERE T.FBILLID = T1.FID
   AND T.FACCOUNTID = T2.FID
   AND T1.FPERIODID = T3.FID
   AND T.FCURRENCYID = T4.FID
   AND T1.FCOMPANYID = T5.FID
   AND T5.FNUMBER = 'ZRT';

--ƾ֤��¼��--TS
select t.c_id            as c_jourid, --��¼id
       t.c_billid        as c_voucherid, --ƾ֤id
       0                 as c_fundid, --����id
       t1.d_bizdate      as d_busi, --ҵ������
       t1.c_description  as c_digest, --ƾ֤ժҪ
       t.f_seq           as l_rowid, --��¼��
       t2.c_number       as c_subcode, --��Ŀ����
       t2.c_name         as c_subname, --��Ŀ����
       t.f_entrydc       as l_baldir, --����
       0                 as f_debit, --���ҽ跽
       0                 as f_credit, --���Ҵ���
       t4.c_number       as c_cykind, --���ִ���
       null              as f_exch, --����
       null              as f_foreign, --��ҽ��
       t1.f_bizstatus    as l_state, --ƾ֤״̬
       t3.f_periodyear   as l_year, --������
       t3.f_periodnumber as l_month, --����·�
       null              as c_combid --���id
  from ts_ea_voucherent  t,
       ts_ea_voucher     t1,
       ts_ea_accountview t2,
       ts_ea_period      t3,
       ts_ea_currency    t4
 where t.c_billid = t1.c_id
   and t.c_accountid = t2.c_id
   and t1.c_periodid = t3.c_id
   and t.c_currencyid = t4.c_id;

--������ϸ--EAS
SELECT T1.FID AS C_DTLID, --��ϸID
       T1.FENTRYID AS C_JOURID, --��¼ID
       T1.FSEQ AS C_INSEQNO, --�������
       T3.FNUMBER AS C_DEPTNO, --���ű��
       T2.FACCOUNTCUSSENTID AS C_CLIENTNO, --������λ,��Ϊ��
       T8.FNUMBER AS C_STAFFNO, --Ա�����
       T4.FNUMBER AS C_PRODCODE, --��Ʒ���
       T9.FNUMBER AS C_BANKACCNO, --�˻����
       NULL AS L_BALDIR, --����
       DECODE(T5.FENTRYDC, 1, T1.FLOCALAMOUNT, 0) AS F_DEBIT, --���ҽ跽
       DECODE(T5.FENTRYDC, 0, T1.FLOCALAMOUNT, 0) AS F_CREDIT --���Ҵ���
  FROM T_GL_VOUCHERASSISTRECORD T1,
       T_BD_ASSISTANTHG         T2,
       T_ORG_COSTCENTER         T3,
       T_BD_GENERALASSTACTTYPE  T4,
       T_GL_VOUCHERENTRY        T5,
       T_GL_VOUCHER             T6,
       T_ORG_COMPANY            T7,
       T_BD_PERSON              T8,
       T_BD_ACCOUNTBANKS        T9
 WHERE T1.FASSGRPID = T2.FID
   AND T2.FCOSTORGID = T3.FID(+) --����
   AND T2.FGENERALASSACTTYPE6ID = T4.FID(+) --��Ʒ
   AND T2.FPERSONID = T8.FID(+) --Ա��
   AND T2.FBANKACCOUNTID = T9.FID(+) --�����˻� 
   AND T1.FENTRYID = T5.FID
   AND T1.FBILLID = T6.FID
   AND T6.FCOMPANYID = T7.FID
   AND T7.FNUMBER = 'ZRT';


--��������
select t.c_id     as c_classid, --����id
       t.c_number as c_classno, --������
       t.c_name   as c_classname, --��������
       null       as c_fclassid, --����id
       null       as c_remark --��ע
  from ts_ea_generalasstacttypegrp t;

--������Ϣ��--EAS
select t.fid       as c_deptid, --����id
       t.fnumber   as c_deptcode, --���ű��
       t.fname_l2     as c_deptname, --��������
       t.fparentid as c_parentid, --�ϼ�����id
       t.fisstart  as c_isvoid, --�Ƿ�ʧЧ
  from t_org_admin t;  
  
--������Ϣ��
select t.c_id       as c_deptid, --����id
       t.c_number   as c_deptcode, --���ű��
       t.c_name     as c_deptname, --��������
       t.c_parentid as c_parentid, --�ϼ�����id
       t.f_isstart  as c_isvoid --�Ƿ�ʧЧ
  from ts_ea_admin t;

--Ա����Ϣ--EAS
select t.fid          as c_staffid, --Ա��d
       t1.fid        as c_deptid, --��������d
       t.fnumber      as c_staffcode, --Ա����
       t.fname_l2     as c_staffname, --Ա������
       null           as c_idtype, --֤�����ͣ�Ա��Ĭ��Ϊ���֤
       t.fidcardno    as c_idcard, --֤������
       null           as c_ctqcno, --��ҵ�ʸ�֤��
       null           as c_posting, --ְ�񣬿��Թ�����������ڶ��ְ����������ʱ�ſ�
       null           as c_issenior, --�Ƿ�߹�
       null           as c_nostaff, --�Ƿ��ޱ���
       t.fstate       as c_status, --��ְ״̬
       t.fcell        as c_mobile, --�ֻ�
       t.fofficephone as c_tel, --�绰
       t.femail       as c_email, --����
       null           as c_msgmode, --��Ϣ��ʽ
       null           as c_remark --��ע
  from t_bd_person t, t_org_admin t1
 where t.fhrorgunitid = t1.fid;  
  
--Ա����Ϣ
select t.fid          as c_staffid, --Ա��d
       t1.c_id        as c_deptid, --��������d
       t.fnumber      as c_staffcode, --Ա����
       t.fname_l2     as c_staffname, --Ա������
       null           as c_idtype, --֤�����ͣ�Ա��Ĭ��Ϊ���֤
       t.fidcardno    as c_idcard, --֤������
       null           as c_ctqcno, --��ҵ�ʸ�֤��
       null           as c_posting, --ְ�񣬿��Թ�����������ڶ��ְ����������ʱ�ſ�
       null           as c_issenior, --�Ƿ�߹�
       null           as c_nostaff, --�Ƿ��ޱ���
       t.fstate       as c_status, --��ְ״̬
       t.fcell        as c_mobile, --�ֻ�
       t.fofficephone as c_tel, --�绰
       t.femail       as c_email, --����
       null           as c_msgmode, --��Ϣ��ʽ
       null           as c_remark --��ע
  from ts_ea_person t, ts_ea_admin t1
 where t.fhrorgunitid = t1.c_id
   and t.fid = t2.fpersonid;

--��Ʒ��Ϣ

--�����˻�
select t.c_id                as c_accid, --�˻�id
       t.c_name              as c_accname, --�ʻ�����
       t.c_bankaccountnumber as c_accno, --�ʻ��˺�
       t1.c_name             as c_orgname, --������������
       t.c_bank              as c_headbankno, --�������б��
       t.f_isclosed          as c_isvoid --�Ƿ�ʧЧ
  from ts_ea_accountbanks t, ts_ea_company t1
 where t.c_companyid = t1.c_id;
