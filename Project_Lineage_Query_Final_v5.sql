/*Oracle EBS OLTP connection pool*/
/*Project_Lineage_Query_Final_v5*/
/*
    prj     = project
    tsk     = task
    agr     = agreement
    po      = purchase order
    dt      = date
    inv     = invoice
    ap      = account payable(s)
    ar      = account receivable(s)
    id      = specific ebs assigned row id
    no      = specific id used in the business
    cnty    = county
    rev     = revision
    descr   = description
    awd     = award
    cncl = cancle/canceled
    rtng = retainage
    amt = amount
    dist = distribution
    qty = quantity
*/

with
    ebs_pa_projects as (
        select
            1 as "ORDINAL_SORT"
            ,'PROJECT' as "DATA_GROUP"
            ,'EBS\Projects\PA_PROJECTS_ALL\PA_PROJECT_STATUSES\PA_PROJECT_CLASSES' as "DATA_SOURCE"
            ,pa_prj_all.PROJECT_ID as "column1"      -- as "ebs_prj_id"          
            ,pa_prj_all.LONG_NAME as "column2"       -- as "ebs_prj_long_name"
            ,pa_prj_all.SEGMENT1 as "column3"        -- as "ebs_prj_no"
            ,pa_prj_all.PROJECT_TYPE as "column4"    -- as "ebs_prj_type"
            ,pa_prj_all.DESCRIPTION as "column5"     -- as "ebs_prj_descr"
            ,pa_prj_all.START_DATE as "column6"      -- as "ebs_prj_star_dt"
            ,pa_prj_all.COMPLETION_DATE  as "column7" -- as "ebs_prj_completion_dt"
            ,pa_prj_status.PROJECT_STATUS_NAME as "column8"    -- as "ebs_prj_status"
            ,prj_class_neighborhood.CLASS_CODE as "column9" -- as "ebs_prj_neighborhood_code"
            ,prj_program.CLASS_CODE as "column10" --  as "ebs_prj_program_code"
            ,prj_sub_program.CLASS_CODE as "column11" --  as "ebs_prj_sub_program_code"
            ,prj_step_process.CLASS_CODE as "column12" --  as "ebs_prj_step_process"
            ,prj_fund_class.CLASS_CODE as "column13" --  as "ebs_prj_fund_class"
            ,prj_class_category.CLASS_CODE as "column14" --  as "ebs_prj_master_project"            
            ,prj_program_type.CLASS_CODE as "column15" --  as "ebs_prj_program_type"
            ,prj_service_impact.CLASS_CODE as "column16" --  as "ebs_prj_service_impact"
            ,prj_impact_fee_zone.CLASS_CODE as "column17" --  as "ebs_prj_impact_fee_zone"
            ,prj_commissioner_district.CLASS_CODE as "column18" --  as "ebs_prj_commissioner_district"
            ,pa_prj_all.CREATION_DATE as "column49" -- as "ebs_prj_create_dt"
            ,pa_prj_all.LAST_UPDATE_DATE as "column50" -- as "ebs_prj_update_dt"                                                       
        from PA_PROJECTS_ALL pa_prj_all
        left join PA_PROJECT_STATUSES pa_prj_status
            on(pa_prj_all.PROJECT_STATUS_CODE = pa_prj_status.PROJECT_STATUS_CODE)
        left join PA_PROJECT_CLASSES prj_class_neighborhood
            on(
                pa_prj_all.PROJECT_ID = prj_class_neighborhood.PROJECT_ID
                    and
                prj_class_neighborhood.CLASS_CATEGORY = 'Neighborhood Com  - Capital'
            )
        left join PA_PROJECT_CLASSES prj_program
            on(
                pa_prj_all.PROJECT_ID = prj_program.PROJECT_ID
                    and
                prj_program.CLASS_CATEGORY = 'CNTY Program'
            )
        left join PA_PROJECT_CLASSES prj_sub_program
            on(
                pa_prj_all.PROJECT_ID = prj_sub_program.PROJECT_ID
                    and
                prj_sub_program.CLASS_CATEGORY = 'CNTY Sub Program'            
            )
        left join PA_PROJECT_CLASSES prj_step_process
            on(
                pa_prj_all.PROJECT_ID = prj_step_process.PROJECT_ID
                    and
                prj_step_process.CLASS_CATEGORY = 'CNTY Two Step Process'
            )
        left join PA_PROJECT_CLASSES prj_fund_class
            on(
                pa_prj_all.PROJECT_ID = prj_fund_class.PROJECT_ID
                    and
                prj_fund_class.CLASS_CATEGORY = 'CNTY CIP Fund'
            )
        left join PA_PROJECT_CLASSES prj_class_category
            on(
                pa_prj_all.PROJECT_ID = prj_class_category.PROJECT_ID
                    and
                prj_class_category.CLASS_CATEGORY = 'CNTY Master Project'
            )
        left join PA_PROJECT_CLASSES prj_program_type
            on(
                pa_prj_all.PROJECT_ID = prj_program_type.PROJECT_ID
                    and
                prj_program_type.CLASS_CATEGORY = 'CNTY Program Type Code'
            )
        left join PA_PROJECT_CLASSES prj_service_impact
            on(
                pa_prj_all.PROJECT_ID = prj_service_impact.PROJECT_ID
                    and
                prj_service_impact.CLASS_CATEGORY = 'CNTY Level of Service Impact'
            )
        left join PA_PROJECT_CLASSES prj_impact_fee_zone
            on(
                pa_prj_all.PROJECT_ID = prj_impact_fee_zone.PROJECT_ID
                    and
                prj_impact_fee_zone.CLASS_CATEGORY = 'CNTY Impact Fee Zone'
            )
        left join PA_PROJECT_CLASSES prj_commissioner_district
            on(
                pa_prj_all.PROJECT_ID = prj_commissioner_district.PROJECT_ID
                    and
                prj_commissioner_district.CLASS_CATEGORY = 'CNTY Commissioner District'
            )
        
        where pa_prj_all.ORG_ID = 102
        --and pa_prj_all.PROJECT_STATUS_CODE = 'APPROVED'
        --and pa_prj_all.SEGMENT1 = 'C69600000'
        and pa_prj_all.SEGMENT1 like 'C%'
        order by
            pa_prj_all.PROJECT_ID asc       
    )
--select * from ebs_pa_projects
,
    ebs_pa_tasks as (
        select
            2 as "ORDINAL_SORT"
            ,'PROJECT_TASK' as "DATA_GROUP"
            ,'EBS\Projects\PA_TASKS' as "DATA_SOURCE"
            ,ebs_pa_tasks.PROJECT_ID as "column1" -- as "ebs_pa_tsk_prj_id"
            ,ebs_pa_tasks.TASK_ID as "column2" -- as "ebs_pa_tsk_tsk_id"
            ,(
                select
                    top_task.TASK_NUMBER
                from PA_TASKS top_task
                where top_task.TASK_ID = ebs_pa_tasks.TOP_TASK_ID
                and top_task.PROJECT_ID = ebs_pa_tasks.PROJECT_ID
            ) as "column3" -- as "ebs_pa_tsk_top_tsk_no"
            ,ebs_pa_tasks.TASK_NUMBER as "column4"-- as "ebs_pa_tsk_tsk_no"
            ,ebs_pa_tasks.LONG_TASK_NAME as "column5" -- as "ebs_pa_tsk_name"
            ,ebs_pa_tasks.DESCRIPTION as "column6" -- as "ebs_pa_tsk_tsk_descr"
            ,ebs_pa_tasks.START_DATE as "column7" -- as "ebs_pa_tsk_tsk_start_dt"
            ,ebs_pa_tasks.COMPLETION_DATE as "column8" -- as "ebs_pa_tsk_end_dt"
            ,ebs_pa_tasks.ATTRIBUTE3 as "column9" -- as "ebs_pa_tsk_center"
            ,ebs_pa_tasks.ATTRIBUTE4 as "column10" -- as "ebs_pa_tsk_tsk_activity"
            ,ebs_pa_tasks.ATTRIBUTE5 as "column11"  -- as "ebs_pa_tsk_tsk_sub_acct"
            ,ebs_pa_tasks.ATTRIBUTE7 as "column12" -- as "ebs_pa_tsk_status"
            ,ebs_pa_tasks.ATTRIBUTE8 as "column13" -- as "ebs_pa_tsk_pde_phase"
            ,ebs_pa_tasks.CREATION_DATE as "column49" -- as "ebs_prj_tsk_create_dt"
            ,ebs_pa_tasks.LAST_UPDATE_DATE as "column50" -- as "ebs_prj_tsk_update_dt"
        from ebs_pa_projects
        inner join PA_TASKS ebs_pa_tasks
            on(ebs_pa_projects."column1" = ebs_pa_tasks.PROJECT_ID)
        where 1=1
        --and ebs_pa_tasks.TASK_ID <> '00000'
        order by
            ebs_pa_tasks.PROJECT_ID asc
            ,ebs_pa_tasks.TASK_ID asc
    )
--select * from ebs_pa_tasks
,
    ebs_gms_awards as (
        select
            3 as "ORDINAL_SORT"
            ,'PROJECT_AWARDS' as "DATA_GROUP"
            ,'EBS\Grants\GMS_AWARDS_ALL\GMS_BUDGET_VERSIONS' as "DATA_SOURCE"
            ,gms_budget_ver.PROJECT_ID as "column1" -- as "ebs_awd_prj_id"
            ,gms_budget_ver.AWARD_ID as "column2" -- as "ebs_awd_awd_id"
            ,nvl(gms_budget_ver.BURDENED_COST,0) as "column3" -- as "ebs_awd_allocation"
            ,gms_awards.AWARD_NUMBER as "column4" -- as "ebs_awd_awd_no"
            ,gms_awards.AWARD_SHORT_NAME as "column5" -- as "ebs_awd_short_name"
            ,gms_awards.AWARD_FULL_NAME as "column6" -- as "ebs_awd_long_name"
            ,gms_awards.FUNDING_SOURCE_AWARD_NUMBER as "column7" -- as "ebs_awd_src_no"
            ,gms_awards.AWARD_PURPOSE_CODE as "column8" -- as "ebs_awd_purpose_code"
            ,gms_awards.STATUS as "column9" -- as "ebs_awd_status"           
            ,gms_awards.START_DATE_ACTIVE as "column10" -- as "ebs_awd_start_dt"
            ,gms_awards.END_DATE_ACTIVE as "column11" -- as "ebs_awd_end_dt"
            ,gms_awards.CLOSE_DATE as "column12" -- as "ebs_awd_close_dt"
            ,gms_awards.ATTRIBUTE1 as "column13" -- as "ebs_awd_fund_no"
            ,gms_awards.ATTRIBUTE4 as "column14" -- as "ebs_awd_activity"
            ,gms_awards.TYPE as "column15" -- as "ebs_awd_type"
            ,nvl(sum(gms_award_dist_exp.RAW_COST),0) as "column16" -- as "ebs_awd_expended"
            ,gms_budget_ver.CREATION_DATE as "column49" -- as "ebs_awd_create_dt"
            ,gms_budget_ver.LAST_UPDATE_DATE as "column50" -- as "ebs_awd_update_dt"
        from GMS_BUDGET_VERSIONS gms_budget_ver
        inner join GMS_AWARDS_ALL gms_awards
            on
                (
                    gms_awards.ORG_ID = 102
                        and
                    gms_budget_ver.AWARD_ID = gms_awards.AWARD_ID
                )        
        left join GMS_AWARD_DISTRIBUTIONS gms_award_dist_exp
            on
                (
                    gms_budget_ver.PROJECT_ID = gms_award_dist_exp.PROJECT_ID
                        and
                    gms_budget_ver.AWARD_ID = gms_award_dist_exp.AWARD_ID
                        and
                    gms_award_dist_exp.DOCUMENT_TYPE = 'EXP'
                )
        where gms_budget_ver.BUDGET_STATUS_CODE = 'B'
        and gms_budget_ver.CURRENT_FLAG = 'Y'
        group by
            gms_budget_ver.PROJECT_ID
            ,gms_budget_ver.AWARD_ID
            ,gms_budget_ver.BURDENED_COST
            ,gms_awards.AWARD_NUMBER
            ,gms_awards.AWARD_SHORT_NAME
            ,gms_awards.AWARD_FULL_NAME
            ,gms_awards.FUNDING_SOURCE_AWARD_NUMBER
            ,gms_awards.AWARD_PURPOSE_CODE
            ,gms_awards.STATUS
            ,gms_awards.START_DATE_ACTIVE
            ,gms_awards.END_DATE_ACTIVE
            ,gms_awards.CLOSE_DATE
            ,gms_awards.ATTRIBUTE1
            ,gms_awards.ATTRIBUTE4
            ,gms_awards.TYPE
            ,gms_budget_ver.CREATION_DATE
            ,gms_budget_ver.LAST_UPDATE_DATE
        order by
            gms_budget_ver.PROJECT_ID asc
            ,gms_budget_ver.AWARD_ID asc

    )
--select * from ebs_gms_awards
,
    po_requisition_dists as (
        select
            4 as "ORDINAL_SORT"
            ,'REQ_DISTS' as "DATA_GROUP"
            ,'EBS\Procurement\PO_REQ_DISTRIBUTIONS_ALL\HR_ALL_ORGANIZATION_UNITS\PO_REQUISITION_LINES_ALL\GL_CODE_COMBINATIONS\GMS_AWARDS_ALL' as "DATA_SOURCE"
            ,po_req_dist.REQUISITION_LINE_ID as "column1" -- as "ebs_req_dist_ln_id"
            ,po_req_dist.DISTRIBUTION_ID as "column2" -- as "ebs_req_dist_id"
            ,po_req_dist.CODE_COMBINATION_ID as "column3" -- as "ebs_req_dist_code_id"
            ,po_req_dist.PROJECT_ID as "column4" -- as "ebs_req_dist_prj_id"
            ,po_req_dist.TASK_ID as "column5" -- as "ebs_req_dist_tsk_id"
            ,gcc.SEGMENT1 as "column6" --  as "ebs_req_dist_fund"
            ,(
                select
                    flv.description
                from apps.fnd_flex_values_vl flv
                left join apps.fnd_flex_Value_sets fvs
                    on(flv.FLEX_VALUE_SET_ID = fvs.FLEX_VALUE_SET_ID)
                where fvs.FLEX_VALUE_SET_NAME = 'CNTY_FUND'
                and flv.FLEX_VALUE = gcc.SEGMENT1   
            ) as "column7" --  as "ebs_req_dist_fund_name"
            ,gcc.SEGMENT2 as "column8" -- as "ebs_req_dist_center"
            ,(
                select
                    flv.description
                from apps.fnd_flex_values_vl flv
                left join apps.fnd_flex_Value_sets fvs
                    on(flv.FLEX_VALUE_SET_ID = fvs.FLEX_VALUE_SET_ID)
                where fvs.FLEX_VALUE_SET_NAME = 'CNTY_CENTER'
                and flv.FLEX_VALUE = gcc.SEGMENT2
            ) as "column9" --  as "ebs_req_dist_center_name"
            ,gcc.SEGMENT3 as "column10" --  as "ebs_req_dist_account"
            ,(
                select
                    flv.description
                from apps.fnd_flex_values_vl flv
                left join apps.fnd_flex_Value_sets fvs
                    on(flv.FLEX_VALUE_SET_ID = fvs.FLEX_VALUE_SET_ID)
                where fvs.FLEX_VALUE_SET_NAME = 'CNTY_ACCOUNT'
                and flv.FLEX_VALUE = gcc.SEGMENT3   
            ) as "column11" --  as "ebs_req_dist_account_name"
            ,gcc.SEGMENT4 as "column12" --  as "ebs_req_dist_sub_account"
            ,gcc.SEGMENT5 as "column13" --  as "ebs_req_dist_activity"
            ,po_req_dist.EXPENDITURE_TYPE as "column14" -- as "ebs_req_dist_exp_type"
            ,nvl(po_req_dist.REQ_LINE_QUANTITY,0) as "column15" -- as "ebs_req_dist_ln_qty"
            ,nvl(po_req_dist.REQ_LINE_AMOUNT,0) as "column16" -- as "ebs_req_dist_ln_amt"
            ,po_req_dist.REQ_AWARD_ID as "column17" -- as "ebs_req_dist_award_id"            
            ,gms_awards.AWARD_NUMBER as "column18" -- as "ebs_req_dist_award_no"
            ,po_req_dist.EXPENDITURE_ORGANIZATION_ID as "column19" -- as "ebs_req_dist_expend_org_id"
            ,hr_org.NAME as "column20" -- as "ebs_req_dist_expend_org"
            ,hr_org.ATTRIBUTE1 as "column21" -- as "ebs_req_dist_expend_admin"
            ,po_req_dist.GL_ENCUMBERED_DATE as "column22" -- as "ebs_req_dist_enc_dt"
            ,po_req_dist.GL_CANCELLED_DATE as "column23" -- as "ebs_req_dist_canceled_dt"
            ,po_req_dist.EXPENDITURE_ITEM_DATE as "column24" -- as "ebs_req_dist_expend_itm_dt"
            ,nvl(po_req_dist.ENCUMBERED_AMOUNT,0) as "column25" -- as "ebs_req_dist_enc_amt"
            ,po_req_line.BLANKET_PO_HEADER_ID as "column26" -- as "ebs_req_ln_agr_id"
            ,po_req_line.BLANKET_PO_LINE_NUM as "column27" -- as "ebs_req_ln_agr_ln_no"
            ,po_req_line.REQUISITION_HEADER_ID as "column28" -- as "ebs_req_ln_header_id"
            ,po_req_dist.CREATION_DATE as "column49" -- as "ebs_req_dist_create_dt"
            ,po_req_dist.LAST_UPDATE_DATE as "column50" -- as "ebs_req_dist_update_dt"
        from PO_REQ_DISTRIBUTIONS_ALL po_req_dist        
        inner join (
            select
                "column1"
                ,"column2"
            from ebs_pa_tasks
            group by
                "column1"
                ,"column2"            
        ) return_id_set
            on
            (
                po_req_dist.ORG_ID = 102
                    and
                po_req_dist.PROJECT_ID = return_id_set."column1"
                    and
                po_req_dist.TASK_ID = return_id_set."column2"
            )            
        left join HR_ALL_ORGANIZATION_UNITS hr_org
            on
                (
                    hr_org.BUSINESS_GROUP_ID = 84
                        and
                    po_req_dist.EXPENDITURE_ORGANIZATION_ID = hr_org.ORGANIZATION_ID
                )                      
        left join PO_REQUISITION_LINES_ALL po_req_line
            on
                (
                    po_req_line.ORG_ID = 102
                        and
                    po_req_dist.REQUISITION_LINE_ID = po_req_line.REQUISITION_LINE_ID                     
                )           
        inner join GL_CODE_COMBINATIONS gcc
            on(po_req_dist.CODE_COMBINATION_ID = gcc.CODE_COMBINATION_ID)
        left join GMS_AWARDS_ALL gms_awards
            on
                (
                    gms_awards.ORG_ID = 102
                        and
                    po_req_dist.REQ_AWARD_ID = gms_awards.AWARD_ID
                )
        order by
            po_req_dist.REQUISITION_LINE_ID asc
            ,po_req_dist.DISTRIBUTION_ID asc
    )
--select * from po_requisition_dists

,
    po_requisition_lines as (
        select
            5 as "ORDINAL_SORT"
            ,'REQ_LINES' as "DATA_GROUP"
            ,'EBS\Procurement\PO_REQUISITION_LINES_ALL\MTL_CATEGORIES_VL\MTL_SYSTEM_ITEMS_B' as "DATA_SOURCE"
            ,po_req_line.REQUISITION_HEADER_ID as "column1" -- as "ebs_req_ln_header_id"
            ,po_req_line.REQUISITION_LINE_ID as "column2" -- as "ebs_req_ln_id"
            ,po_req_line.LINE_NUM as "column3" -- as "ebs_req_ln_no"
            ,po_req_line.ITEM_DESCRIPTION as "column4" -- as "ebs_req_ln_itm_descr"
            ,po_req_line.UNIT_MEAS_LOOKUP_CODE as "column5" -- as "ebs_req_ln_uom"
            ,nvl(po_req_line.UNIT_PRICE,0) as "column6" -- as "ebs_req_ln_up"
            ,nvl(po_req_line.QUANTITY,0) as "column7" -- as "ebs_req_ln_qty"
            ,nvl(po_req_line.QUANTITY_DELIVERED,0) as "column8" -- as "ebs_req_ln_qty_delivered"
            ,po_req_line.NEED_BY_DATE as "column9" -- as "ebs_req_ln_need_by_dt"
            ,po_req_line.NOTE_TO_AGENT as "column10" -- as "ebs_req_ln_agent_note"
            ,po_req_line.NOTE_TO_RECEIVER as "column11" -- as "ebs_req_ln_receiver_note"
            ,po_req_line.DOCUMENT_TYPE_CODE as "column12" -- as "ebs_req_ln_doc_type"
            ,po_req_line.BLANKET_PO_HEADER_ID as "column13" -- as "ebs_req_ln_agr_id"
            ,po_req_line.BLANKET_PO_LINE_NUM as "column14" -- as "ebs_req_ln_agr_ln_no"
            ,po_req_line.CANCEL_FLAG as "column15" -- as "ebs_req_ln_cncl_flg"
            ,nvl(po_req_line.QUANTITY_CANCELLED,0) as "column16" -- as "ebs_req_ln_cncl_qty"
            ,po_req_line.CANCEL_DATE as "column17" -- as "ebs_req_ln_cncl_dt"
            ,po_req_line.CANCEL_REASON as "column18" -- as "ebs_req_ln_cncl_note"
            ,po_req_line.VENDOR_ID as "column19" -- as "ebs_req_ln_vendor_id"
            ,po_req_line.VENDOR_SITE_ID as "column20" -- as "ebs_req_ln_vendor_site_id"
            ,po_req_line.VENDOR_CONTACT_ID as "column21" -- as "ebs_req_ln_vendor_contact_id"
            ,po_req_line.ATTRIBUTE1 as "column22" -- as "ebs_req_ln_dept"
            ,po_req_line.PCARD_FLAG as "column23" -- as "ebs_req_ln_pcard_flg"
            ,po_req_line.NOTE_TO_VENDOR as "column24" -- as "ebs_req_ln_vendor_note"
            ,po_req_line.ORDER_TYPE_LOOKUP_CODE as "column25" -- as "ebs_req_ln_order_type"
            ,po_req_line.PURCHASE_BASIS as "column26" -- as "ebs_req_ln_purch_basis" 
            ,nvl(po_req_line.BASE_UNIT_PRICE,0) as "column27" -- as "ebs_req_ln_base_up"
            ,po_req_line.ATTRIBUTE2 as "column28" -- as "ebs_req_ln_wo_no"
            ,nvl(nvl(po_req_line.AMOUNT,(nvl(po_req_line.UNIT_PRICE,0)*nvl(po_req_line.QUANTITY,0))),0) as "column29" -- as "ebs_req_ln_amt"
            ,po_req_line.CATEGORY_ID as "column30" -- as "ebs_req_ln_cat_id" --##NEW## 03/13/2021
            ,mtl_cat.SEGMENT1||'.'||mtl_cat.SEGMENT2 as "column31" -- as "ebs_req_ln_cat_code" --##NEW## 03/13/2021
            ,mtl_cat.DESCRIPTION as "column32" -- as "ebs_req_ln_cat_descr" --##NEW## 03/13/2021
            ,po_req_line.ITEM_ID as "column33" -- as "ebs_req_ln_item_id" --##NEW## 03/13/2021
            ,mtl_items.SEGMENT1 as "column34" -- as "ebs_req_ln_item_class_1" --##NEW## 03/13/2021
            ,mtl_items.SEGMENT2 as "column35" -- as "ebs_req_ln_item_class_2" --##NEW## 03/13/2021
            ,mtl_items.SEGMENT3 as "column36" -- as "ebs_req_ln_item_class_3" --##NEW## 03/13/2021
            ,mtl_items.DESCRIPTION as "column37" -- as "ebs_req_ln_item_descr" --##NEW## 03/13/2021
            ,po_req_line.CREATION_DATE as "column49" -- as "ebs_req_ln_create_dt"
            ,po_req_line.LAST_UPDATE_DATE as "column50" -- as "ebs_req_ln_update_dt"
        from PO_REQUISITION_LINES_ALL po_req_line
        inner join (
            select
                "column1"
            from po_requisition_dists
            group by
                "column1"   
        ) return_po_dist_line_id
            on
                (
                    po_req_line.ORG_ID = 102
                        and
                    po_req_line.REQUISITION_LINE_ID = return_po_dist_line_id."column1"
                )
        left join mtl_categories_vl mtl_cat
            on(po_req_line.CATEGORY_ID = mtl_cat.CATEGORY_ID)
        left join MTL_SYSTEM_ITEMS_B mtl_items
            on
                (
                    mtl_items.ORGANIZATION_ID = 104
                        and
                    po_req_line.ITEM_ID = mtl_items.INVENTORY_ITEM_ID
                )            
        order by
            po_req_line.REQUISITION_HEADER_ID asc
            ,po_req_line.REQUISITION_LINE_ID asc
    )
--select * from po_requisition_lines
,
    po_requisition_headers as (
        select
            6 as "ORDINAL_SORT"
            ,'REQ_HEADERS' as "DATA_GROUP"
            ,'EBS\Procurement\PO_REQUISITION_HEADERS_ALL' as "DATA_SOURCE"
            ,po_req_header.REQUISITION_HEADER_ID as "column1" -- as "ebs_req_header_id"
            ,po_req_header.SEGMENT1 as "column2" -- as "ebs_req_header_no"
            ,po_req_header.AUTHORIZATION_STATUS as "column3" -- as "ebs_req_auth_status"
            ,po_req_header.DESCRIPTION as "column4" -- as "ebs_req_header_descr"
            ,po_req_header.NOTE_TO_AUTHORIZER as "column5" -- as "ebs_req_header_auth_note"
            ,po_req_header.CANCEL_FLAG as "column6" -- as "ebs_req_header_cncl_flg"
            ,po_req_header.CLOSED_CODE as "column7" -- as "ebs_req_header_clsd_code"
            ,po_req_header.APPROVED_DATE as "column8" -- as "ebs_req_header_appr_dt"
            ,po_req_header.CREATION_DATE as "column49" -- as "ebs_req_header_create_dt"
            ,po_req_header.LAST_UPDATE_DATE as "column50" -- as "ebs_req_header_update_dt"
        from PO_REQUISITION_HEADERS_ALL po_req_header
        inner join (
            select
                "column1"
            from po_requisition_lines
            group by "column1"
        ) req_lines
            on
                (
                    po_req_header.ORG_ID = 102
                        and
                    po_req_header.REQUISITION_HEADER_ID = req_lines."column1"
                )
        order by
            po_req_header.REQUISITION_HEADER_ID asc
    )
--select * from po_requisition_headers
,
    ebs_po_dist as (
        select
            7 as "ORDINAL_SORT"
            ,'PO_DISTS' as "DATA_GROUP"
            ,'EBS\Purchasing\PO_DISTRIBUTIONS_ALL\PO_LINES_ALL\GL_CODE_COMBINATIONS\GMS_AWARD_DISTRIBUTIONS\GMS_AWARDS_ALL\HR_ALL_ORGANIZATION_UNITS' as "DATA_SOURCE"            
            ,po_dist.PO_HEADER_ID as "column1" -- as "ebs_po_dist_po_header_id"
            ,po_dist.PO_LINE_ID as "column2" --  as "ebs_po_dist_po_line_id"
            ,po_dist.PO_DISTRIBUTION_ID as "column3" --  as "ebs_po_dist_id"
            ,po_dist.CODE_COMBINATION_ID as "column4" --  as "ebs_po_dist_code_combo"
            ,po_dist.DISTRIBUTION_TYPE as "column5" --  as "ebs_po_dist_type"
            ,gcc.SEGMENT1 as "column6" --  as "ebs_po_dist_fund"
            ,(
                select
                    flv.description
                from apps.fnd_flex_values_vl flv
                left join apps.fnd_flex_Value_sets fvs
                    on(flv.FLEX_VALUE_SET_ID = fvs.FLEX_VALUE_SET_ID)
                where fvs.FLEX_VALUE_SET_NAME = 'CNTY_FUND'
                and flv.FLEX_VALUE = gcc.SEGMENT1   
            ) as "column7" --  as "ebs_po_dist_fund_name"
            ,gcc.SEGMENT2 as "column8" -- as "ebs_po_dist_center"
            ,(
                select
                    flv.description
                from apps.fnd_flex_values_vl flv
                left join apps.fnd_flex_Value_sets fvs
                    on(flv.FLEX_VALUE_SET_ID = fvs.FLEX_VALUE_SET_ID)
                where fvs.FLEX_VALUE_SET_NAME = 'CNTY_CENTER'
                and flv.FLEX_VALUE = gcc.SEGMENT2   
            ) as "column9" --  as "ebs_po_dist_center_name"
            ,gcc.SEGMENT3 as "column10" --  as "ebs_po_dist_account"
            ,(
                select
                    flv.description
                from apps.fnd_flex_values_vl flv
                left join apps.fnd_flex_Value_sets fvs
                    on(flv.FLEX_VALUE_SET_ID = fvs.FLEX_VALUE_SET_ID)
                where fvs.FLEX_VALUE_SET_NAME = 'CNTY_ACCOUNT'
                and flv.FLEX_VALUE = gcc.SEGMENT3   
            ) as "column11" --  as "ebs_po_dist_account_name"
            ,gcc.SEGMENT4 as "column12" --  as "ebs_po_dist_sub_account"
            ,gcc.SEGMENT5 as "column13" --  as "ebs_po_dist_activity"
            ,awards_all.AWARD_ID as "column14" -- as "ebs_po_dist_award_id"
            ,nvl(po_dist.ENCUMBERED_AMOUNT,0) as "column15" -- as "ebs_po_dist_enc_amt"
            ,nvl(po_dist.UNENCUMBERED_AMOUNT,0) as "column16" -- as "ebs_po_dist_unenc_amt"
            ,nvl(po_dist.AMOUNT_TO_ENCUMBER,0) as "column17" -- as "ebs_po_dist_to_enc_amt"
            ,nvl(po_dist.AMOUNT_ORDERED,0) as "column18" -- as "ebs_po_dist_ordered_amt"
            ,nvl(po_dist.AMOUNT_DELIVERED,0) as "column19" -- as "ebs_po_dist_delivered_amt"
            ,nvl(po_dist.AMOUNT_CANCELLED,0) as "column20" -- as "ebs_po_dist_amt_cncl"
            ,nvl(po_dist.AMOUNT_REVERSED,0) as "column21" -- as "ebs_po_dist_amt_reversed"
            ,nvl(po_dist.RETAINAGE_RELEASED_AMOUNT,0) as "column22" -- as "ebs_po_dist_rtng_released"
            ,nvl(po_dist.RETAINAGE_WITHHELD_AMOUNT,0) as "column23" -- as "ebs_po_dist_rtng_withheld"
            ,nvl(po_dist.AMOUNT_BILLED,0) as "column24" -- as "ebs_po_dist_amt_billed"
            ,nvl(po_dist.QUANTITY_ORDERED,0) as "column25" -- as "ebs_po_dist_qty_ordered"
            ,nvl(po_dist.UNENCUMBERED_QUANTITY,0) as "column26" -- as "ebs_po_dist_qty_unenc"
            ,nvl(po_dist.QUANTITY_DELIVERED,0) as "column27" -- as "ebs_po_dist_qty_delivered"
            ,nvl(po_dist.QUANTITY_BILLED,0) as "column28" -- as "ebs_po_dist_qty_billed"
            ,nvl(po_dist.QUANTITY_CANCELLED,0) as "column29" -- as "ebs_po_dist_qty_canceled"
            ,po_dist.PROJECT_ID as "column30" -- as "ebs_po_dist_prj_id"
            ,po_dist.TASK_ID as "column31" -- as "ebs_po_dist_tsk_id"
            ,po_dist.REQ_DISTRIBUTION_ID as "column32" -- as "ebs_po_dist_req_dist_id"
            ,po_dist.EXPENDITURE_ORGANIZATION_ID as "column33" -- as "ebs_po_dist_org_expend_id"
            ,hr_org.NAME as "column34" -- as "ebs_po_dist_expend_org"
            ,hr_org.ATTRIBUTE1 as "column35" -- as "ebs_po_dist_expend_admin"
            ,nvl(nvl(po_line.CONTRACT_ID,po_line.FROM_HEADER_ID),po_header.FROM_HEADER_ID) as "column36" -- as "ebs_po_ln_agr_id"
            ,awards_all.AWARD_NUMBER as "column37" -- as "ebs_po_dist_award_no"
            ,po_dist.EXPENDITURE_TYPE as "column38" -- as "ebs_po_dist_expend_type" --##NEW## 3/10/2021
            ,po_dist.EXPENDITURE_ITEM_DATE as "column39" -- as "ebs_po_dist_expend_dt" --##NEW## 3/10/2021
            ,po_dist.CREATION_DATE as "column49" -- as "po_dist_create_dt"
            ,po_dist.LAST_UPDATE_DATE as "column50" -- as "po_dist_update_dt"
        from PO_DISTRIBUTIONS_ALL po_dist
        inner join (
            select
                "column1"
                ,"column2"
            from ebs_pa_tasks
            group by
                "column1"
                ,"column2"            
        ) return_id_set
            on
            (
                po_dist.ORG_ID = 102
                    and
                po_dist.PROJECT_ID = return_id_set."column1"
                    and
                po_dist.TASK_ID = return_id_set."column2"
            )
        left join PO_LINES_ALL po_line
            on
                (
                    po_line.ORG_ID =102
                        and
                    po_dist.PO_HEADER_ID = po_line.PO_HEADER_ID
                        and
                    po_dist.PO_LINE_ID = po_line.PO_LINE_ID

                )
        left join PO_HEADERS_ALL po_header
            on(po_line.PO_HEADER_ID = po_header.PO_HEADER_ID)
        inner join GL_CODE_COMBINATIONS gcc
            on(po_dist.CODE_COMBINATION_ID = gcc.CODE_COMBINATION_ID)           
        left join GMS_AWARD_DISTRIBUTIONS gms_award_dist
            on(po_dist.AWARD_ID = gms_award_dist.AWARD_SET_ID)            
        left join GMS_AWARDS_ALL awards_all
            on
                (
                    awards_all.ORG_ID = 102
                        and
                    gms_award_dist.AWARD_ID = awards_all.AWARD_ID
                )
        left join HR_ALL_ORGANIZATION_UNITS hr_org
            on
                (
                    hr_org.BUSINESS_GROUP_ID = 84
                        and
                    po_dist.EXPENDITURE_ORGANIZATION_ID = hr_org.ORGANIZATION_ID
                )
        order by
            po_dist.PO_HEADER_ID asc
            ,po_dist.PO_LINE_ID asc
            ,po_dist.PO_DISTRIBUTION_ID asc
    )
--select * from ebs_po_dist
,
    ebs_po_lines as (
        select
            8 as "ORDINAL_SORT"
            ,'PO_LINES' as "DATA_GROUP"
            ,'EBS\Purchasing\PO_LINES_ALL\MTL_CATEGORIES_VL\MTL_SYSTEM_ITEMS_B' as "DATA_SOURCE"
            ,po_line.PO_HEADER_ID as "column1" -- as "ebs_po_ln_header_id"
            ,po_line.PO_LINE_ID as "column2" -- as "ebs_po_ln_ln_id"
            ,po_line.LINE_NUM as "column3" -- as "ebs_po_ln__no"
            ,nvl(nvl(po_line.CONTRACT_ID,po_line.FROM_HEADER_ID),po_header.FROM_HEADER_ID) as "column4" -- as "ebs_po_ln_agr_id"
            ,po_line.CLOSED_FLAG as "column5" -- as "ebs_po_ln_close" 
            ,po_line.CANCEL_FLAG as "column6" -- as "ebs_po_ln_cncl_flg"
            ,po_line.ITEM_DESCRIPTION as "column7" -- as "ebs_po_ln_descr"
            ,nvl(po_line.RETAINAGE_RATE,0) as "column8" -- as 'ebs_po_ln_rtng_rt'
            ,po_line.UNIT_MEAS_LOOKUP_CODE as "column9" -- as "ebs_po_ln_unit_lookup"
            ,nvl(po_line.UNIT_PRICE,0) as "column10" -- as "ebs_po_ln_unit_price"
            ,nvl(po_line.QUANTITY,0) as "column11" -- as "ebs_po_ln_qty"
            ,po_line.MATCHING_BASIS as "column12" -- as "ebs_po_ln_matching_basis"
            ,po_line.CANCEL_DATE as "column13" -- as "ebs_po_ln_cancel_dt"
            ,po_line.CANCEL_REASON as "column14" -- as "ebs_po_ln_cancel_descr"
            ,po_line.CLOSED_DATE as "column15" -- as "ebs_po_ln_close_dt"
            ,po_line.CLOSED_REASON as "column16" -- as "ebs_po_ln_close_descr"
            ,nvl(nvl(po_line.AMOUNT,(nvl(po_line.UNIT_PRICE,0)*nvl(po_line.QUANTITY,0))),0) as "column17" -- as "ebs_po_ln_amt"
            ,po_line.CATEGORY_ID as "column18" -- as "ebs_po_ln_cat_id" --##NEW## 03/10/2021
            ,mtl_cat.SEGMENT1||'.'||mtl_cat.SEGMENT2 as "column19" -- as "ebs_po_ln_cat_code" --##NEW## 03/10/2021
            ,mtl_cat.DESCRIPTION as "column20" -- as "ebs_po_ln_cat_descr" --##NEW## 03/10/2021
            ,po_line.ITEM_ID as "column21" -- as "ebs_po_ln_item_id" --##NEW## 03/10/2021
            ,mtl_items.SEGMENT1 as "column22" -- as "ebs_po_ln_item_class_1" --##NEW## 03/13/2021
            ,mtl_items.SEGMENT2 as "column23" -- as "ebs_po_ln_item_class_2" --##NEW## 03/13/2021
            ,mtl_items.SEGMENT3 as "column24" -- as "ebs_po_ln_item_class_3" --##NEW## 03/13/2021
            ,mtl_items.DESCRIPTION as "column25" -- as "ebs_po_ln_item_descr" --##NEW## 03/13/2021
            ,po_line.CREATION_DATE as "column49" -- as "po_ln_create_dt"
            ,po_line.LAST_UPDATE_DATE as "column50" -- as "po_ln_update_dt"
        from PO_LINES_ALL po_line
        inner join (
            select
                "column1"
                ,"column2"
            from ebs_po_dist
            group by
                "column1"
                ,"column2"
        ) return_dist_line
            on(
                po_line.ORG_ID = 102
                    and 
                po_line.PO_HEADER_ID = return_dist_line."column1"
                    and
                po_line.PO_LINE_ID = return_dist_line."column2"
            )
        inner join PO_HEADERS_ALL po_header
            on(po_line.PO_HEADER_ID = po_header.PO_HEADER_ID)
        left join MTL_CATEGORIES_VL mtl_cat
            on(po_line.CATEGORY_ID = mtl_cat.CATEGORY_ID)
        left join MTL_SYSTEM_ITEMS_B mtl_items
            on
                (
                    mtl_items.ORGANIZATION_ID = 104
                        and
                    po_line.ITEM_ID = mtl_items.INVENTORY_ITEM_ID
                )
        order by
            po_line.PO_HEADER_ID asc
            ,po_line.PO_LINE_ID asc
    )
--select * from ebs_po_lines
,
    ebs_po_headers as (
        select
            9 as "ORDINAL_SORT"
            ,'PO_HEADERS' as "DATA_GROUP"
            ,'EBS\Purchasing\PO_HEADERS_ALL\PON_AUCTION_HEADERS_ALL\PON_BID_HEADERS\PER_ALL_PEOPLE_F\PER_ALL_ASSIGNMENTS_F\HR_ALL_POSITIONS_F\HR_ALL_ORGANIZATION_UNITS' as "DATA_SOURCE"            
            ,po_header.PO_HEADER_ID as "column1" -- as "ebs_po_header_id"
            ,po_header.SEGMENT1 as "column2" -- as "ebs_po_header_po_no"
            ,po_header.CANCEL_FLAG as "column3" -- as "ebs_po_header_cncl_flg"
            ,po_header.AUTHORIZATION_STATUS as "column4" -- as "ebs_po_header_auth_status"
            ,po_header.APPROVED_DATE as "column5" -- as "ebs_po_header_approved_dt"
            ,po_header.CLOSED_CODE as "column6" -- as "ebs_po_header_closed_code"
            ,po_header.CLOSED_DATE as "column7" -- as "ebs_po_header_closed_dt"
            ,po_header.COMMENTS as "column8" -- as "ebs_po_header_title"
            ,po_header.REVISION_NUM as "column9" -- as "ebs_po_header_rev_no"
            ,po_header.REVISED_DATE as "column10" -- as "ebs_po_header_rev_dt"
            ,po_header.VENDOR_ID as "column11" -- as "ebs_po_header_vendor_id"
            ,po_header.VENDOR_SITE_ID as "column12" -- as "ebs_po_header_vendor_site_id"
            ,po_header.VENDOR_CONTACT_ID as "column13" -- as "ebs_po_header_vendor_contact_id"
            ,po_header.ATTRIBUTE3 as "column14" -- as "ebs_po_header_doc_no" ##NEW## 3/10/2021
            ,po_header.ATTRIBUTE4 as "column15" -- as "ebs_po_header_bid_src" ##NEW## 3/10/2021
            ,po_header.ATTRIBUTE5 as "column16" -- as "ebs_po_header_bid_no" ##NEW## 3/10/2021
            ,agreement_agent.FULL_NAME as "column17" -- as "ebs_po_header_agent" ##NEW## 3/10/2021
            ,po_header.ATTRIBUTE9 as "column18" -- as "ebs_po_header_renew_code" ##NEW## 3/10/2021
            ,agreement_manager.FULL_NAME as "column19" -- as "ebs_po_header_manager" ##NEW## 3/10/2021
            ,agreement_dept.NAME as "column20" -- as "ebs_po_header_managing_dept" ##NEW## 3/10/2021
            ,po_header.TYPE_LOOKUP_CODE as "column21" -- as "ebs_po_header_type" ##NEW## 3/10/2021
            ,ebs_bid_header.AUCTION_HEADER_ID as "column22" -- as "ebs_po_header_auc_header_id" --##NEW## 3/10/2021
            ,ebs_bid_header.BID_NUMBER as "column23" -- as "ebs_po_header_bid_id" --##NEW## 3/10/2021
            ,po_header.FROM_HEADER_ID as "column24" -- as "ebs_po_header_from_header" --##NEW## 3/19/2021
            ,po_doc_type.STYLE_DESCRIPTION as "column25" -- as "ebs_po_header_doc_type" --##NEW## 3/19/2021
            ,po_header.CREATION_DATE as "column49" -- as "ebs_po_header_create_dt"
            ,po_header.LAST_UPDATE_DATE as "column50" -- as "ebs_po_header_update_dt"
        from PO_HEADERS_ALL po_header
        inner join (            
            select
                "column1"
            from ebs_po_lines
            group by
                "column1"            
        ) return_po_header_id
            on(
                po_header.ORG_ID = 102
                    and
                po_header.PO_HEADER_ID = return_po_header_id."column1"
                    and
                po_header.TYPE_LOOKUP_CODE = 'STANDARD'
            )
        left join PON_AUCTION_HEADERS_ALL ebs_auction_header
            on(po_header.ATTRIBUTE5 = ebs_auction_header.DOCUMENT_NUMBER)
        left join PO_DOC_STYLE_HEADERS po_doc_type
            on(po_header.STYLE_ID = po_doc_type.STYLE_ID)
        left join PON_BID_HEADERS ebs_bid_header
            on
                (
                    ebs_auction_header.AUCTION_HEADER_ID = ebs_bid_header.AUCTION_HEADER_ID
                        and
                    po_header.VENDOR_ID = ebs_bid_header.VENDOR_ID
                        and
                    po_header.VENDOR_SITE_ID = ebs_bid_header.VENDOR_SITE_ID
                )
        left join PER_ALL_PEOPLE_F agreement_agent
            on(
                po_header.AGENT_ID = agreement_agent.PERSON_ID
                    and
                trunc(sysdate)
                    between
                trunc(agreement_agent.EFFECTIVE_START_DATE)
                    and
                trunc(agreement_agent.EFFECTIVE_END_DATE)   
            )
        left join PER_ALL_PEOPLE_F agreement_manager
            on(
                po_header.ATTRIBUTE2 = agreement_manager.PERSON_ID
                    and
                trunc(sysdate)
                    between
                trunc(agreement_manager.EFFECTIVE_START_DATE)
                    and
                trunc(agreement_manager.EFFECTIVE_END_DATE)
            )
        left join PER_ALL_ASSIGNMENTS_F per_all_assign
            on(
                agreement_manager.PERSON_ID = per_all_assign.PERSON_ID
                    and
                trunc(sysdate)
                    between
                trunc(per_all_assign.EFFECTIVE_START_DATE)
                    and
                trunc(per_all_assign.EFFECTIVE_END_DATE)
                    and
                per_all_assign.ASSIGNMENT_TYPE = 'E'
            )
        left join HR_ALL_POSITIONS_F hr_all_pos
            on(
                per_all_assign.POSITION_ID = hr_all_pos.POSITION_ID
                    and
                trunc(sysdate)
                    between
                trunc(hr_all_pos.EFFECTIVE_START_DATE)
                    and
                trunc(hr_all_pos.EFFECTIVE_END_DATE)
            )
        left join HR_ALL_POSITIONS_F hr_all_pos
            on(
                per_all_assign.POSITION_ID = hr_all_pos.POSITION_ID
                    and
                trunc(sysdate)
                    between
                trunc(hr_all_pos.EFFECTIVE_START_DATE)
                    and
                trunc(hr_all_pos.EFFECTIVE_END_DATE)
            )
        left join HR_ALL_ORGANIZATION_UNITS agreement_dept
            on(
                hr_all_pos.ORGANIZATION_ID = agreement_dept.ORGANIZATION_ID
                    and
                trunc(sysdate)
                    between
                trunc(agreement_dept.DATE_FROM)
                    and
                trunc(nvl(agreement_dept.DATE_TO,sysdate))
            )
        order by
            ebs_bid_header.AUCTION_HEADER_ID asc
            ,ebs_bid_header.BID_NUMBER asc
            ,po_header.PO_HEADER_ID asc
            ,po_header.VENDOR_ID asc
            ,po_header.VENDOR_SITE_ID asc
    )
--select * from ebs_po_headers
,
    ebs_po_agreements as (       
        select
            10 as "ORDINAL_SORT"
            ,'PO_AGREEMENTS' as "DATA_GROUP"
            ,'EBS\Purchasing\PO_HEADERS_ALL\PON_AUCTION_HEADERS_ALL\PON_BID_HEADERS\PER_ALL_PEOPLE_F\PER_ALL_ASSIGNMENTS_F\HR_ALL_POSITIONS_F\HR_ALL_ORGANIZATION_UNITS' as "DATA_SOURCE"                                     
            ,po_agreement.PO_HEADER_ID as "column1" -- as "ebs_agr_id"
            ,po_agreement.SEGMENT1 as "column2" -- as "ebs_agr_no"
            ,agreement_manager.FULL_NAME as "column3" -- as "ebs_agr_manager"
            ,agreement_dept.NAME as "column4" -- as "ebs_managing_dept"
            ,agreement_agent.FULL_NAME as "column5" -- as "ebs_agr_agent"
            ,po_agreement.ATTRIBUTE5 as "column6" -- as "ebs_agr_bid_no"
            ,po_agreement.START_DATE as "column7" -- as "ebs_agr_term_start_dt"
            ,po_agreement.END_DATE as "column8" -- as "ebs_agr_term_end_dt"
            ,po_agreement.ATTRIBUTE3 as "column9" -- as "ebs_agr_doc_no"
            ,po_agreement.TYPE_LOOKUP_CODE as "column10" -- as "ebs_agr_type"
            ,po_agreement.ATTRIBUTE4 as "column11" -- as "ebs_agr_src_type"
            ,DECODE(
                po_agreement.ATTRIBUTE4,
                    'SS','Sole Source'
                    ,'FLSC','State Contract' 
                    ,'RQUAL','Request for Qualifications' 
                    ,'RFP','Request for Proposal' 
                    ,'RPS','Request for Professional Services' 
                    ,'RAT','Ratification (after-the-fact)' 
                    ,'OCC','Other Competitive Contract' 
                    ,'ITB','Invitation to Bid' 
                    ,'IGOV','Inter-governmental' 
                    ,'RFQ','Informal Quotation' 
                    ,'HCGPC','Governmental Purchasing Council' 
                    ,'FSGA','Federal Government Contract (GSA)' 
                    ,'EXPRO','Exempt from Procurement'
                    ,'EMERG','Emergency Purchase'
                    ,'DPCM','Direct Purchase of Construction Materials'
                    ,'DPUR','Direct Purchase Below Competitive Threshold (<$5,000)'
                    ,'COOP','Cooperative Purchases'
                ,'Source Description Not Found'
            ) as "column12" -- as "ebs_agr_src_descr"
            ,po_agreement.ATTRIBUTE9 as "column13" -- as "ebs_agr_renew_code"
            ,po_agreement.AUTHORIZATION_STATUS as "column14" -- as "ebs_agr_auth_status"
            ,po_agreement.APPROVED_DATE as "column15" -- as "ebs_agr_auth_dt"
            ,po_agreement.CANCEL_FLAG as "column16" -- as "ebs_agr_cncl"
            ,po_agreement.CONTERMS_EXIST_FLAG as "column17" -- as "ebs_agr_terms"
            ,po_agreement.REVISION_NUM as "column18" -- as "ebs_agr_rev_no"
            ,po_agreement.REVISED_DATE as "column19" -- as "ebs_agr_rev_dt"
            ,po_agreement.NOTE_TO_VENDOR as "column20" -- as "ebs_agr_vendor_note"
            ,po_agreement.NOTE_TO_RECEIVER as "column21" -- as "ebs_agr_receive_note"
            ,po_agreement.NOTE_TO_AUTHORIZER as "column22" -- as "ebs_agr_authorizer_note"
            ,po_agreement.COMMENTS as "column23" -- as "ebs_agr_title"
            ,nvl(po_agreement.BLANKET_TOTAL_AMOUNT,0) as "column24" -- as "ebs_agr_amt"
            ,po_agreement.VENDOR_ID as "column25" -- as "ebs_agr_vendor_id"
            ,po_agreement.VENDOR_SITE_ID as "column26" -- as "ebs_agr_vendor_site_id"
            ,po_agreement.VENDOR_CONTACT_ID as "column27" -- as "ebs_agr_vendor_contact_id"
            ,po_agreement.FROM_HEADER_ID as "column28" -- as "ebs_agr_from_header_id"
            ,case
                when po_agreement.CANCEL_FLAG = 'Y' then
                    'CANCELED'
                when po_agreement.AUTHORIZATION_STATUS <> 'APPROVED' then
                    'PENDING APPROVAL'
                when trunc(po_agreement.START_DATE) > trunc(sysdate) then
                    'PENDING START'
                when trunc(po_agreement.END_DATE) <= trunc(sysdate) then
                    'EXPIRED'
                else
                    'ACTIVE'
            end as "column29" -- as "ebs_agr_active_status"
            ,ebs_bid_header.AUCTION_HEADER_ID as "column30" -- as "ebs_agr_auc_header_id" --##NEW## 3/10/2021
            ,ebs_bid_header.BID_NUMBER as "column31" -- as "ebs_agr_bid_id" --##NEW## 3/10/2021
            ,po_doc_type.STYLE_DESCRIPTION as "column32" -- as "ebs_agr_doc_type" --##NEW## 3/19/2021            
            ,po_agreement.CREATION_DATE as "column49" -- as "ebs_agr_create_dt"
            ,po_agreement.LAST_UPDATE_DATE as "column50" -- as "ebs_agr_update_dt"
        from PO_HEADERS_ALL po_agreement
        inner join (
            select
                results."po_agreement_id"
            from (
                select
                    resultsA."po_agreement_id"
                from (
                        select
                            po_requisition_dists."column26" as "po_agreement_id"
                        from po_requisition_dists
                        where 1=1
                        and
                            (
                                po_requisition_dists."column21" = 'CADPW'
                                    or
                                po_requisition_dists."column21" = 'CADPU'
                            )
                        and po_requisition_dists."column26" is not null
                        union all
                        select
                            ebs_po_dist."column36" as "po_agreement_id"
                        from ebs_po_dist
                        where 1=1
                        and
                            (
                                ebs_po_dist."column35" = 'CADPW'
                                    or
                                ebs_po_dist."column35" = 'CADPU'
                            )
                        and ebs_po_dist."column36" is not null
                ) resultsA
                union all
                select
                    po_header.PO_HEADER_ID as "po_agreement_id"
                from PO_HEADERS_ALL po_header
                inner join (
                        select
                            po_requisition_dists."column26" as "join_agreement_id"
                        from po_requisition_dists
                        where 1=1
                        and
                            (
                                po_requisition_dists."column21" = 'CADPW'
                                    or
                                po_requisition_dists."column21" = 'CADPU'
                            )
                        and po_requisition_dists."column26" is not null
                        union all
                        select
                            ebs_po_dist."column36" as "join_agreement_id"
                        from ebs_po_dist
                        where 1=1
                        and
                            (
                                ebs_po_dist."column35" = 'CADPW'
                                    or
                                ebs_po_dist."column35" = 'CADPU'
                            )                            
                        and ebs_po_dist."column36" is not null
                ) resultsB
                    on(po_header.FROM_HEADER_ID = resultsB."join_agreement_id")
            ) results
            group by
                results."po_agreement_id"
        ) return_po_agreement_id
            on
                (
                    po_agreement.PO_HEADER_ID = return_po_agreement_id."po_agreement_id"
                        and
                    (
                        po_agreement.TYPE_LOOKUP_CODE = 'CONTRACT' --##NEW## 3/10/2021
                            or
                        po_agreement.TYPE_LOOKUP_CODE = 'BLANKET' --##NEW## 3/10/2021
                    )
                )
        left join PON_AUCTION_HEADERS_ALL ebs_auction_header
            on(po_agreement.ATTRIBUTE5 = ebs_auction_header.DOCUMENT_NUMBER)
        left join PON_BID_HEADERS ebs_bid_header
            on
                (
                    ebs_auction_header.AUCTION_HEADER_ID = ebs_bid_header.AUCTION_HEADER_ID
                        and
                    po_agreement.VENDOR_ID = ebs_bid_header.VENDOR_ID
                        and
                    po_agreement.VENDOR_SITE_ID = ebs_bid_header.VENDOR_SITE_ID
                )
        left join PO_DOC_STYLE_HEADERS po_doc_type
            on(po_agreement.STYLE_ID = po_doc_type.STYLE_ID)                
        left join PER_ALL_PEOPLE_F agreement_agent
            on(
                po_agreement.AGENT_ID = agreement_agent.PERSON_ID
                    and
                trunc(sysdate)
                    between
                trunc(agreement_agent.EFFECTIVE_START_DATE)
                    and
                trunc(agreement_agent.EFFECTIVE_END_DATE)
            )
        left join PER_ALL_PEOPLE_F agreement_manager
            on(
                po_agreement.ATTRIBUTE2 = agreement_manager.PERSON_ID
                    and
                trunc(sysdate)
                    between
                trunc(agreement_manager.EFFECTIVE_START_DATE)
                    and
                trunc(agreement_manager.EFFECTIVE_END_DATE)
            )
        left join PER_ALL_ASSIGNMENTS_F per_all_assign
            on(
                agreement_manager.PERSON_ID = per_all_assign.PERSON_ID
                    and
                trunc(sysdate)
                    between
                trunc(per_all_assign.EFFECTIVE_START_DATE)
                    and
                trunc(per_all_assign.EFFECTIVE_END_DATE)
                    and
                per_all_assign.ASSIGNMENT_TYPE = 'E'
            )
        left join HR_ALL_POSITIONS_F hr_all_pos
            on(
                per_all_assign.POSITION_ID = hr_all_pos.POSITION_ID
                    and
                trunc(sysdate)
                    between
                trunc(hr_all_pos.EFFECTIVE_START_DATE)
                    and
                trunc(hr_all_pos.EFFECTIVE_END_DATE)
            )           
        left join HR_ALL_POSITIONS_F hr_all_pos
            on(
                per_all_assign.POSITION_ID = hr_all_pos.POSITION_ID
                    and
                trunc(sysdate)
                    between
                trunc(hr_all_pos.EFFECTIVE_START_DATE)
                    and
                trunc(hr_all_pos.EFFECTIVE_END_DATE)
            )
        left join HR_ALL_ORGANIZATION_UNITS agreement_dept
            on(
                hr_all_pos.ORGANIZATION_ID = agreement_dept.ORGANIZATION_ID
                    and
                trunc(sysdate)
                    between
                trunc(agreement_dept.DATE_FROM)
                    and
                trunc(nvl(agreement_dept.DATE_TO,sysdate))
            )
        order by
            ebs_bid_header.AUCTION_HEADER_ID asc
            ,ebs_bid_header.BID_NUMBER asc
            ,po_agreement.PO_HEADER_ID asc
            ,po_agreement.VENDOR_ID asc
            ,po_agreement.VENDOR_SITE_ID asc
    )
--select * from ebs_po_agreements
,
    ebs_agr_pay_items as (
        select
            11 as "ORDINAL_SORT"
            ,'AGREEMENT_BID_ITEMS' as "DATA_GROUP"
            ,'EBS\Sourcing\PON_AUCTION_HEADERS_ALL\PON_BID_ITEM_PRICES\PON_BID_HEADERS\PON_AUCTION_ITEM_PRICES_ALL\AP_SUPPLIERS\MTL_CATEGORIES_VL' as "DATA_SOURCE"            
            ,bid_header.AUCTION_HEADER_ID as "column1" -- as "ebs_auc_header_id"
            ,bid_header.BID_NUMBER as "column2" -- as "ebs_auc_bid_no_id"
            ,bid_header.VENDOR_ID as "column3" -- as "ebs_bid_vendor_id"
            ,ap_supplier.VENDOR_NAME as "column4" -- as "ebs_bid_vendor_name"
            ,bid_header.VENDOR_SITE_ID as "column5" -- as "ebs_bid_vendor_site_id"
            ,bid_header.PO_HEADER_ID as "column6" -- as "ebs_bid_po_header_id"
            ,bid_header.AWARD_STATUS as "column7" -- as "ebs_bid_award_status"
            ,bid_header.CONTRACT_TYPE as "column8" -- as "ebs_bid_contract_type"
            ,bid_item_price.CATEGORY_ID as "column9" -- as "ebs_auc_itm_cat_id"
            ,bid_item_price.CATEGORY_NAME  as "column10" -- as "ebs_auc_itm_cat_name"
            ,auc_item_price.ORDER_TYPE_LOOKUP_CODE as "column11" -- as "ebs_auc_itm_order_type"
            ,auc_item_price.PURCHASE_BASIS as "column12" -- as "ebs_auc_itm_purch_basis"
            ,auc_item_price.SUB_LINE_SEQUENCE_NUMBER as "column13" -- as "ebs_auc_itm_line_no"
            ,auc_item_price.DISP_LINE_NUMBER as "column14" -- as "ebs_auc_itm_disp_line_no"
            ,bid_item_price.ITEM_DESCRIPTION as "column15" -- as "ebs_auc_itm_descr"
            ,nvl(nvl(bid_item_price.AWARD_QUANTITY,auc_item_price.QUANTITY),0) as "column16" -- as "ebs_auc_itm_qty"
            ,auc_item_price.UOM_CODE as "column17" -- as "ebs_auc_itm_uom_code"
            ,auc_item_price.UNIT_OF_MEASURE as "column18" -- as "ebs_auc_itm_uom_descr"
            ,nvl(bid_item_price.AWARD_PRICE,0) as "column19" -- as "ebs_auc_itm_awd_price"
            ,ebs_auction_header.DOCUMENT_NUMBER as "column20" -- as "ebs_auc_bid_no"
            ,null as "column21" -- ##NEW## 3/10/2021
            ,auc_item_price.LINE_NUMBER as "column22" -- as "ebs_auc_itm_ln_no" ##NEW## 3/10/2021
            ,auc_item_price.DOCUMENT_DISP_LINE_NUMBER as "column23" -- as "ebs_auc_itm_doc_ln_no" ##NEW## 3/10/2021
            ,auc_item_price.REQUISITION_NUMBER as "column24" -- as "ebs_auc_itm_req_no" ##NEW## 3/10/2021
            ,mtl_cat.DESCRIPTION as "column25" -- as "ebs_auc_itm_cat_descr" ##NEW## 3/10/2021
            ,auc_item_price.CREATION_DATE as "column49" -- as "ebs_auc_itm_create_dt"
            ,auc_item_price.LAST_UPDATE_DATE as "column50" -- as "ebs_auc_itm_update_dt"
        from PON_AUCTION_HEADERS_ALL ebs_auction_header
        inner join PON_BID_ITEM_PRICES bid_item_price
            on(
                ebs_auction_header.AUCTION_HEADER_ID = bid_item_price.AUCTION_HEADER_ID
                    and
                (
                    bid_item_price.AWARD_STATUS = 'AWARDED'
                        or
                    bid_item_price.AWARD_STATUS = 'PARTIAL'
                )
            )
        inner join PON_BID_HEADERS bid_header
            on(
                ebs_auction_header.ORG_ID = 102
                    and
                bid_item_price.AUCTION_HEADER_ID = bid_header.AUCTION_HEADER_ID
                    and
                bid_item_price.BID_NUMBER = bid_header.BID_NUMBER    
            )
        inner join PON_AUCTION_ITEM_PRICES_ALL auc_item_price
            on(
                bid_item_price.AUCTION_HEADER_ID = auc_item_price.AUCTION_HEADER_ID
                    and
                bid_item_price.AUCTION_LINE_NUMBER = auc_item_price.LINE_NUMBER
                    and
                auc_item_price.AWARD_STATUS = 'COMPLETED'
                    and
                auc_item_price.ORG_ID = 102
            )
        inner join (
            select
                results."bid_no"
            from
                (
                    select
                        ebs_po_headers."column16" as "bid_no"
                    from ebs_po_headers
                        union all
                    select
                        ebs_po_agreements."column6" as "bid_no"
                    from ebs_po_agreements
                ) results
            group by
                results."bid_no"
        ) return_bid_no_set
            on(ebs_auction_header.DOCUMENT_NUMBER = return_bid_no_set."bid_no")
        inner join AP_SUPPLIERS ap_supplier
            on(bid_header.VENDOR_ID = ap_supplier.VENDOR_ID)
        left join MTL_CATEGORIES_VL mtl_cat
            on(auc_item_price.CATEGORY_ID = mtl_cat.CATEGORY_ID)
        order by
            bid_header.AUCTION_HEADER_ID asc
            ,bid_header.BID_NUMBER asc
            ,auc_item_price.LINE_NUMBER asc
            ,auc_item_price.SUB_LINE_SEQUENCE_NUMBER asc
            ,bid_header.VENDOR_ID asc

    )
--select * from ebs_agr_pay_items
,
    ebs_auction_header as (
        select
            12 as "ORDINAL_SORT"
            ,'AUCTION_HEADER' as "DATA_GROUP"
            ,'EBS\Sourcing\PON_AUCTION_HEADERS_ALL\PON_FORMS_INSTANCES\PON_FORM_SECTION_COMPILED\PON_FORM_FIELD_VALUES' as "DATA_SOURCE"
            ,auc_header.AUCTION_HEADER_ID as "column1" -- as "ebs_auc_header_id"
            ,auc_header.DOCUMENT_NUMBER as "column2" --  as "ebs_auc_bid_no"
            ,auc_header.AUCTION_TITLE as "column3" --  as "ebs_auc_title"
            ,auc_header.EVENT_TITLE as "column4" --  as "ebs_auc_event_title"
            ,auc_header.AUCTION_STATUS as "column5" --  as "ebs_auc_status"
            ,auc_header.AWARD_STATUS as "column6" --  as "ebs_auc_award_status"
            ,auc_header.AUCTION_TYPE as "column7" --  as "ebs_auc_type"
            ,auc_header.CONTRACT_TYPE as "column8" --  as "ebs_auc_contract_type"
            ,auc_header.TRADING_PARTNER_CONTACT_ID as "column9" --  as "ebs_auc_partner_id"
            ,auc_header.OPEN_BIDDING_DATE as "column10" --  as "ebs_auc_open_bid_dt"
            ,auc_header.CLOSE_BIDDING_DATE as "column11" --  as "ebs_auc_close_bid_dt"
            ,auc_header.OUTCOME_STATUS as "column12" --  as "ebs_auc_outcome"
            ,auc_header.AWARD_COMPLETE_DATE as "column13" --  as "ebs_auc_complete_dt"
            ,auc_header.AWARD_DATE as "column14" --  as "ebs_auc_award_dt"
            ,auc_header.APPROVAL_STATUS as "column15" --  as "ebs_auc_appr_stat"
            ,auc_header.AWARD_APPROVAL_STATUS as "column16" --  as "ebs_auc_award_appr_stat"
            ,auc_header.AMENDMENT_NUMBER as "column17" --  as "ebs_auc_amend_no"
            ,auc_header.AMENDMENT_DESCRIPTION as "column18" --  as "ebs_auc_amend_desc"
            ,case
                when form_sec_comp.MAPPING_FIELD_VALUE_COLUMN = 'Textcol2' then
                    form_field_vals.TEXTCOL2
                when form_sec_comp.MAPPING_FIELD_VALUE_COLUMN = 'Textcol4' then
                    form_field_vals.TEXTCOL4
                else
                    'NO_TEXT_COLUMN_IDENTIFIED'
            end as "column19" --as "ebs_auc_req_no"
            ,po_doc_type.STYLE_DESCRIPTION as "column20" -- as "ebs_auc_doc_type" --##NEW## 3/19/2021            
            ,auc_header.CREATION_DATE as "column49" --  as "ebs_auc_create_dt"
            ,auc_header.LAST_UPDATE_DATE as "column50" --  as "ebs_auc_update_dt"
        from PON_AUCTION_HEADERS_ALL auc_header
        inner join (
            select
                "column20"
            from ebs_agr_pay_items
            group by
                "column20"
        ) return_bid_no
            on(return_bid_no."column20" = auc_header.DOCUMENT_NUMBER)
        left join PO_DOC_STYLE_HEADERS po_doc_type
            on(auc_header.PO_STYLE_ID = po_doc_type.STYLE_ID)            
        inner join PON_FORMS_INSTANCES form_instance
            on(
                auc_header.AUCTION_HEADER_ID = form_instance.ENTITY_PK1
                    and
                form_instance.ENTITY_CODE = 'PON_AUCTION_HEADERS_ALL'
                        and
                form_instance.STATUS = 'DATA_ENTERED'
                    and
                form_instance.CREATION_DATE = (
                    select
                        max(max_date.CREATION_DATE)
                    from PON_FORMS_INSTANCES max_date
                    where max_date.ENTITY_PK1 = form_instance.ENTITY_PK1
                )
            )
        inner join PON_FORM_SECTION_COMPILED form_sec_comp
            on(
                    form_instance.FORM_ID = form_sec_comp.FORM_ID
                        and
                    form_sec_comp.FIELD_CODE = 'PRJ1_REQUISITION'
                        and
                    form_sec_comp.TYPE = 'SECTION_FIELD' 
            )
        inner join PON_FORM_FIELD_VALUES form_field_vals
            on(
                    form_field_vals.OWNING_ENTITY_CODE = 'PON_AUCTION_HEADERS_ALL'
                        and
                    form_field_vals.SECTION_ID = -1
                        and
                    form_field_vals.TEXTCOL1 <> 'BOCC'
                        and
                    form_instance.ENTITY_PK1 = form_field_vals.ENTITY_PK1
                        and
                    form_sec_comp.FORM_ID = form_field_vals.FORM_ID
            )
        left join po_requisition_headers
            on(
                form_field_vals.TEXTCOL2 = po_requisition_headers."column2"
                    or
                form_field_vals.TEXTCOL4 = po_requisition_headers."column2"
            )
        where auc_header.AUCTION_STATUS = 'AUCTION_CLOSED'
        and auc_header.AWARD_STATUS = 'COMPLETED'
        and auc_header.OUTCOME_STATUS = 'OUTCOME_COMPLETED'
        and auc_header.APPROVAL_STATUS = 'APPROVED'
        and auc_header.ORG_ID = 102
        order by
            auc_header.AUCTION_HEADER_ID asc
    )
--select * from ebs_auction_header
,
    ebs_ap_inv_dists as (
        select
            13 as "ORDINAL_SORT"
            ,'AP_INV_DISTRIBUTIONS' as "DATA_GROUP"
            ,'EBS\Accounts Payable\AP_INVOICE_DISTRIBUTIONS_ALL\GL_CODE_COMBINATIONS\GMS_AWARD_DISTRIBUTIONS\GMS_AWARDS_ALL\HR_ALL_ORGANIZATION_UNITS' as "DATA_SOURCE"            
            ,ap_inv_dist.INVOICE_ID as "column1" -- as "ebs_ap_inv_dist_inv_id"            
            ,ap_inv_dist.INVOICE_LINE_NUMBER as "column2" -- as "ebs_ap_inv_dist_inv_ln_no"
            ,ap_inv_dist.DISTRIBUTION_LINE_NUMBER as "column3" -- as "ebs_ap_inv_dist_ln_no"                        
            ,ap_inv_dist.INVOICE_DISTRIBUTION_ID as "column4" -- as "ebs_ap_inv_dist_id"
            ,ap_inv_dist.PO_DISTRIBUTION_ID as "column5" -- as "ebs_ap_inv_dist_po_dist_id"
            ,ap_inv_dist.DIST_CODE_COMBINATION_ID as "column6" -- as "ebs_ap_inv_dist_code_combo_id"
            ,ap_inv_dist.PROJECT_ID as "column7" -- as "ebs_ap_inv_dist_prj_id"
            ,ap_inv_dist.TASK_ID as "column8" -- as "ebs_ap_inv_dist_tsk_id"
            ,ap_inv_dist.AWARD_ID as "column9" -- as "ebs_ap_inv_dist_awd_id"
            ,ap_inv_dist.ACCOUNTING_DATE as "column10" -- as "ebs_ap_inv_dist_acct_dt"
            ,ap_inv_dist.EXPENDITURE_ITEM_DATE as "column11" -- as "ebs_ap_inv_dist_exp_dt"
            ,ap_inv_dist.EXPENDITURE_TYPE as "column12" -- as "ebs_ap_inv_dist_exp_type"
            ,ap_inv_dist.DIST_MATCH_TYPE as "column13" -- as "ebs_ap_inv_dist_match_type"
            ,ap_inv_dist.MATCHED_UOM_LOOKUP_CODE as "column14" -- as "ebs_ap_inv_dist_match_uom"
            ,ap_inv_dist.REVERSAL_FLAG as "column15" -- as "ebs_ap_inv_dist_rvrs_flg"
            ,ap_inv_dist.CANCELLATION_FLAG as "column16" -- as "ebs_ap_inv_dist_cncl_flg"                      
            ,nvl(ap_inv_dist.QUANTITY_INVOICED,0) as "column17" -- as "ebs_ap_inv_dist_qty"
            ,nvl(ap_inv_dist.UNIT_PRICE,0) as "column18" -- as "ebs_ap_inv_dist_up"                        
            ,nvl(ap_inv_dist.TOTAL_DIST_BASE_AMOUNT,0) as "column19" -- as "ebs_ap_inv_dist_base_amt"                       
            ,nvl(ap_inv_dist.TOTAL_DIST_AMOUNT,0) as "column20" -- as "ebs_ap_inv_dist_amt"
            ,nvl(ap_inv_dist.RETAINED_AMOUNT_REMAINING,0) as "column21" -- as "ebs_ap_inv_dist_rtng_remaining"
            ,gcc.SEGMENT1  as "column22" -- as "ebs_ap_inv_dist_fund_no"                        
            ,(
                select
                    flv.description
                from apps.fnd_flex_values_vl flv
                left join apps.fnd_flex_Value_sets fvs
                    on(flv.FLEX_VALUE_SET_ID = fvs.FLEX_VALUE_SET_ID)
                where fvs.FLEX_VALUE_SET_NAME = 'CNTY_FUND'
                and flv.FLEX_VALUE = gcc.SEGMENT1   
            ) as "column23" -- as "ebs_ap_inv_dist_fund_name"                                                            
            ,gcc.SEGMENT2 as "column24" -- as "ebs_ap_inv_dist_center"
            ,(
                select
                    flv.description
                from apps.fnd_flex_values_vl flv
                left join apps.fnd_flex_Value_sets fvs
                    on(flv.FLEX_VALUE_SET_ID = fvs.FLEX_VALUE_SET_ID)
                where fvs.FLEX_VALUE_SET_NAME = 'CNTY_CENTER'
                and flv.FLEX_VALUE = gcc.SEGMENT2   
            ) as "column25" -- as "ebs_ap_inv_dist_center_name"           
            
            ,gcc.SEGMENT3 as "column26" -- as "ebs_ap_inv_dist_acct"
            ,(
                select
                    flv.description
                from apps.fnd_flex_values_vl flv
                left join apps.fnd_flex_Value_sets fvs
                    on(flv.FLEX_VALUE_SET_ID = fvs.FLEX_VALUE_SET_ID)
                where fvs.FLEX_VALUE_SET_NAME = 'CNTY_ACCOUNT'
                and flv.FLEX_VALUE = gcc.SEGMENT3   
            ) as "column27" -- as "ebs_ap_inv_dist_acct_name"                             
            ,gcc.SEGMENT4 as "column28" -- as "ebs_ap_inv_dist_sub_acct"
            ,gcc.SEGMENT5 as "column29" -- as "ebs_ap_inv_dist_activity"
            ,awards_all.AWARD_NUMBER as "column30" -- as "ebs_ap_inv_dist_awd_no"
            ,ap_inv_dist.EXPENDITURE_ORGANIZATION_ID as "column31" -- as "ebs_ap_inv_dist_expend_org_id"
            ,hr_org.NAME as "column32" -- as "ebs_ap_inv_dist_expend_org"                        
            ,hr_org.ATTRIBUTE1 as "column33" -- as "ebs_ap_inv_dist_expend_admin"         
            ,ap_inv_dist.CREATION_DATE as "column49" -- as "ebs_ap_inv_dist_create_dt"
            ,ap_inv_dist.LAST_UPDATE_DATE as "column50" -- as "ebs_ap_inv_dist_update_dt"            
        from AP_INVOICE_DISTRIBUTIONS_ALL ap_inv_dist
        inner join (
            select
                "column3"
            from ebs_po_dist
            group by
                "column3"            
        ) return_po_dist_id
            on(ap_inv_dist.PO_DISTRIBUTION_ID = return_po_dist_id."column3")
        inner join ebs_pa_tasks     
            on(
                ap_inv_dist.PROJECT_ID = ebs_pa_tasks."column1"
                    and
                ap_inv_dist.TASK_ID = ebs_pa_tasks."column2"  
            )
        left join GL_CODE_COMBINATIONS gcc
            on(ap_inv_dist.DIST_CODE_COMBINATION_ID = gcc.CODE_COMBINATION_ID)
        left join GMS_AWARD_DISTRIBUTIONS gms_award_dist
            on(ap_inv_dist.AWARD_ID = gms_award_dist.AWARD_SET_ID)                
        left join GMS_AWARDS_ALL awards_all
            on
                (
                    awards_all.ORG_ID = 102
                        and
                    gms_award_dist.AWARD_ID = awards_all.AWARD_ID
                )
        left join HR_ALL_ORGANIZATION_UNITS hr_org
            on(ap_inv_dist.EXPENDITURE_ORGANIZATION_ID = hr_org.ORGANIZATION_ID)
        order by
            ap_inv_dist.PO_DISTRIBUTION_ID asc        
            ,ap_inv_dist.INVOICE_ID asc
            ,ap_inv_dist.INVOICE_LINE_NUMBER asc
            ,ap_inv_dist.INVOICE_DISTRIBUTION_ID asc
            ,ap_inv_dist.DISTRIBUTION_LINE_NUMBER asc
    )
--select * from ebs_ap_inv_dists
,
    ebs_ap_inv_lines as (
        select
            14 as "ORDINAL_SORT"
            ,'AP_INV_LINES' as "DATA_GROUP"
            ,'EBS\Accounts Payable\AP_INVOICE_LINES_ALL\MTL_SYSTEM_ITEMS_B' as "DATA_SOURCE"                                   
            ,ap_inv_line.INVOICE_ID as "column1" -- as "ebs_ap_inv_ln_inv_id"
            ,ap_inv_line.LINE_NUMBER as "column2" -- as "ebs_ap_inv_ln_no"
            ,ap_inv_line.DESCRIPTION as "column3" -- as "ebs_ap_inv_ln_descr"
            ,ap_inv_line.ITEM_DESCRIPTION as "column4" -- as "ebs_ap_inv_ln_itm_descr"           
            ,ap_inv_line.DISCARDED_FLAG as "column5" -- as "ebs_ap_inv_ln_discard_flg"
            ,ap_inv_line.CANCELLED_FLAG as "column6" -- as "ebs_ap_inv_ln_cancel_flg"
            ,ap_inv_line.LINE_SOURCE as "column7" -- as "ebs_ap_inv_ln_src"
            ,nvl(ap_inv_line.QUANTITY_INVOICED,0) as "column8" -- as "ebs_ap_inv_ln_qty"
            ,ap_inv_line.UNIT_MEAS_LOOKUP_CODE as "column9" -- as "ebs_ap_inv_ln_uom"
            ,nvl(ap_inv_line.UNIT_PRICE,0) as "column10" -- as "ebs_ap_inv_ln_up"
            ,ap_inv_line.INVENTORY_ITEM_ID as "column11" -- as "ebs_ap_inv_ln_item_id" --##NEW## 03/13/2021
            ,mtl_items.SEGMENT1 as "column12" -- as "ebs_ap_inv_ln_item_class_1" --##NEW## 03/13/2021
            ,mtl_items.SEGMENT2 as "column13" -- as "ebs_ap_inv_ln_item_class_2" --##NEW## 03/13/2021
            ,mtl_items.SEGMENT3 as "column14" -- as "ebs_ap_inv_ln_item_class_3" --##NEW## 03/13/2021
            ,mtl_items.DESCRIPTION as "column15" -- as "ebs_ap_inv_ln_item_descr" --##NEW## 03/13/2021
            ,ap_inv_line.PRODUCT_TYPE as "column16" -- as "ebs_ap_inv_ln_product_type" --##NEW## 03/13/2021
            ,ap_inv_line.LINE_TYPE_LOOKUP_CODE as "column17" -- as "ebs_ap_inv_ln_line_code" --##NEW## 03/13/2021
            ,ap_inv_line.RETAINED_INVOICE_ID as "column18" -- as "ebs_ap_inv_ln_rtng_inv_id" --##NEW## 03/13/2021
            ,ap_inv_line.RETAINED_LINE_NUMBER as "column19" -- as "ebs_ap_inv_ln_rtng_line_no" --##NEW## 03/13/2021
            ,nvl(ap_inv_line.AMOUNT,0) as "column20" -- as "ebs_ap_inv_ln_amt" --##NEW## 04/04/2021         
            ,ap_inv_line.CREATION_DATE as "column49" -- as "ebs_ap_inv_ln_create_dt"
            ,ap_inv_line.LAST_UPDATE_DATE as "column50" -- as "ebs_ap_inv_ln_update_dt"
        from AP_INVOICE_LINES_ALL ap_inv_line
        inner join (
            select
                "column1"
                ,"column2"
            from ebs_ap_inv_dists
            group by
                "column1"
                ,"column2"            
        ) return_line
            on
                (
                    ap_inv_line.ORG_ID = 102
                        and
                    ap_inv_line.INVOICE_ID = return_line."column1"
                        and    
                    ap_inv_line.LINE_NUMBER = return_line."column2"
                )
        left join MTL_SYSTEM_ITEMS_B mtl_items
            on
                (
                    mtl_items.ORGANIZATION_ID = 104
                        and
                    ap_inv_line.INVENTORY_ITEM_ID = mtl_items.INVENTORY_ITEM_ID
                )                            
        order by
            ap_inv_line.INVOICE_ID asc
            ,ap_inv_line.LINE_NUMBER asc
    )
--select * from ebs_ap_inv_lines
,
    ebs_ap_inv_headers as (
        select
            15 as "ORDINAL_SORT"
            ,'AP_INV_HEADERS' as "DATA_GROUP"
            ,'EBS\Accounts Payable\AP_INVOICES_ALL\AP_SUPPLIERS' as "DATA_SOURCE"                        
            ,ap_inv_header.INVOICE_ID as "column1" -- as "ebs_ap_inv_id"          
            ,ap_inv_header.INVOICE_NUM as "column2" -- as "ebs_ap_inv_no"
            ,ap_inv_header.DESCRIPTION as "column3" -- as "ebs_ap_inv_descr"
            ,ap_inv_header.GL_DATE as "column4" -- as "ebs_ap_inv_gl_dt"
            ,ap_inv_header.INVOICE_DATE as "column5" -- as "ebs_ap_inv_dt"
            ,ap_inv_header.INVOICE_RECEIVED_DATE as "column6" -- as "ebs_ap_inv_received_dt"
            ,ap_inv_header.CANCELLED_DATE as "column7" -- as "ebs_ap_inv_cncl_dt"
            ,nvl(ap_inv_header.INVOICE_AMOUNT, 0) as "column8" -- as "ebs_ap_inv_amt"
            ,nvl(ap_inv_header.APPROVED_AMOUNT,0) as "column9" -- as "ebs_ap_inv_appr_amt"
            ,ap_inv_header.SOURCE as "column10" -- as "ebs_ap_inv_src"
            ,ap_inv_header.VENDOR_ID as "column11" -- as "ebs_ap_inv_vendor_id"
            ,ap_inv_header.VENDOR_SITE_ID as "column12" -- as "ap_inv_header_vendor_site_id"    
            ,ap_inv_header.VENDOR_CONTACT_ID as "column13" -- as "ap_inv_header_vendor_contact_id"
            ,ap_inv_header.PARTY_ID as "column14" -- as "ap_inv_header_party_id"
            ,ap_inv_header.PARTY_SITE_ID as "column15" -- as "ap_inv_header_party_site_id"  
            ,AP_SUPPLIERS.VENDOR_NAME as "column16" -- as "ap_inv_header_vendor_name"
            ,nvl(ap_inv_header.AMOUNT_APPLICABLE_TO_DISCOUNT,0) as "column17" -- as "ap_inv_header_discount_amt"
            ,nvl(ap_inv_header.CANCELLED_AMOUNT,0) as "column18" -- as "ap_inv_header_canceled_amt"
            ,ap_inv_header.PAY_GROUP_LOOKUP_CODE as "column19" -- as "ap_inv_header_pay_group_code"
            ,ap_inv_header.INVOICE_TYPE_LOOKUP_CODE as "column20" -- as "ap_inv_header_type_lookup_code"       

            ,ap_inv_header.CREATION_DATE as "column49" -- as "ebs_ap_inv_created_dt"
            ,ap_inv_header.LAST_UPDATE_DATE as "column50" -- as "ebs_ap_inv_update_dt"
        from AP_INVOICES_ALL ap_inv_header
        inner join (
            select
                "column1"
            from ebs_ap_inv_lines
            group by "column1"
        ) return_inv_header_id
            on(
                ap_inv_header.ORG_ID = 102
                    and
                ap_inv_header.INVOICE_ID = return_inv_header_id."column1"
            )
        inner join AP_SUPPLIERS
            on(ap_inv_header.VENDOR_ID = AP_SUPPLIERS.VENDOR_ID)
        order by
            ap_inv_header.INVOICE_ID asc
    )
--select * from ebs_ap_inv_headers
,
    ap_inv_payments as (        
        select
            16 as "ORDINAL_SORT"
            ,'AP_INV_PAYMENTS' as "DATA_GROUP"
            ,'EBS\Accounts Payable\AP_INVOICE_PAYMENTS_ALL\AP_CHECKS_ALL' as "DATA_SOURCE"            
            ,ap_inv_payment.INVOICE_ID as "column1" -- as "ebs_ap_inv_invoice_id"
            ,ap_inv_check.CHECKRUN_ID as "column2" -- as "ebs_ap_inv_check_run_id"
            ,ap_inv_check.PAYMENT_ID as "column3" -- as "ebs_ap_inv_payment_id"
            ,ap_inv_check.PAYMENT_METHOD_CODE as "column4" -- as "ebs_ap_inv_paym_method"
            ,ap_inv_check.CHECKRUN_NAME as "column5" -- as "ebs_ap_inv_checkrun_name"
            ,ap_inv_check.CHECK_ID as "column6" -- as "ebs_ap_inv_check_id"
            ,ap_inv_check.CHECK_NUMBER as "column7" --as "ebs_ap_inv_check_no"
            ,ap_inv_check.CHECK_DATE as "column8" -- as "ebs_ap_inv_check_dt"
            ,ap_inv_check.CLEARED_DATE as "column9" -- as "ebs_ap_inv_check_clear_dt"
            ,nvl(ap_inv_payment.AMOUNT,0)  as "column10" -- as "ebs_ap_inv_payment_amt"
            ,ap_inv_payment.ACCOUNTING_EVENT_ID  as "column11" -- as "ebs_ap_inv_acct_event_id"
            ,ap_inv_payment.ACCOUNTING_DATE as "column12" -- as "ebs_ap_inv_acct_dt"
            ,ap_inv_payment.REVERSAL_FLAG as "column13" -- as "ebs_ap_inv_payment_reversed"
            ,ap_inv_check.VENDOR_ID as "column14" -- as "ebs_ap_inv_vendor_id"
            ,ap_inv_check.VENDOR_SITE_ID as "column15" -- as "ebs_ap_inv_vendor_site_id"
            ,ap_inv_payment.PAYMENT_NUM as "column16" -- as "ebs_ap_inv_payment_num"
            ,ap_inv_payment.CREATION_DATE as "column49" -- as "ebs_ap_inv_create_dt"
            ,ap_inv_payment.LAST_UPDATE_DATE as "column50" -- as "ebs_ap_inv_update_dt"              
        from AP_INVOICE_PAYMENTS_ALL ap_inv_payment      
        inner join (
            select
                "column1"-- as "ebs_ap_inv_id"
                ,"column11" -- as "ebs_ap_inv_vendor_id"
                ,"column12" -- as "ap_inv_header_vendor_site_id"
            from ebs_ap_inv_headers
            group by
                "column1"
                ,"column11"
                ,"column12"
        ) return_invoice_id
            on(
                ap_inv_payment.ORG_ID = 102
                    and                
                ap_inv_payment.INVOICE_ID = return_invoice_id."column1"
            )
        left join AP_CHECKS_ALL ap_inv_check
            on(
                ap_inv_check.ORG_ID = 102 
                    and
                ap_inv_payment.CHECK_ID = ap_inv_check.CHECK_ID
                    and
                ap_inv_check.VENDOR_ID = return_invoice_id."column11"
                    and
                ap_inv_check.VENDOR_SITE_ID = return_invoice_id."column12"                  
            )
        order by
            ap_inv_check.CHECK_ID asc
            ,ap_inv_payment.INVOICE_ID asc
            ,ap_inv_check.PAYMENT_ID asc
            ,ap_inv_check.VENDOR_ID asc
            ,ap_inv_payment.ACCOUNTING_EVENT_ID asc           
    )
--select * from ap_inv_payments
,
    suppliers as (
        select
            17 as "ORDINAL_SORT"
            ,'SUPPLIERS' as "DATA_GROUP"
            ,'EBS\Supplier Model\AP_SUPPLIERS' as "DATA_SOURCE"            
            ,ap_supplier.VENDOR_ID as "column1" -- as "ebs_supplier_vendor_id"           
            ,ap_supplier.VENDOR_NAME as "column2" -- as "ebs_supplier_vendor_name"
            ,ap_supplier.START_DATE_ACTIVE as "column3" -- as "ebs_supplier_start_dt"
            ,ap_supplier.END_DATE_ACTIVE as "column4" -- as "ebs_supplier_end_dt"
            ,ap_supplier.PARTY_ID as "column5" -- as "ebs_supplier_party_id"
            ,ap_supplier.PARENT_PARTY_ID as "column6" -- as "ebs_supplier_party_parent_id"
            ,ap_supplier.ENABLED_FLAG as "column7" -- as "ebs_supplier_enabled_flg"
            ,ap_supplier.VENDOR_TYPE_LOOKUP_CODE as "column8" -- as "ebs_supplier_type"
            ,ap_supplier.WOMEN_OWNED_FLAG as "column9" -- as "ebs_supplier_woman_owned"
            ,ap_supplier.SMALL_BUSINESS_FLAG as "column10" -- as "ebs_supplier_small_biz"
            ,ap_supplier.MINORITY_GROUP_LOOKUP_CODE as "column11" -- as "ebs_supplier_minority"

            ,ap_supplier.CREATION_DATE as "column49" -- as "ebs_supplier_created_dt"    
            ,ap_supplier.LAST_UPDATE_DATE as "column50" -- as "ebs_supplier_updated_dt"                        
        from AP_SUPPLIERS ap_supplier
        inner join (
            select
                results."vendor_id"
            from (
                select
                    "column19" as "vendor_id"
                from po_requisition_lines
                union all
                select
                    "column11" as "vendor_id"
                from ebs_po_headers
                union all
                select
                    "column25" as "vendor_id"
                from ebs_po_agreements
                union all
                select
                    "column3" as "vendor_id"
                from ebs_agr_pay_items
                union all
                select
                    "column11" as "vendor_id"
                from ebs_ap_inv_headers
                union all
                select
                    "column15" as "vendor_id"
                from ap_inv_payments                                                                                
            ) results
            where results."vendor_id" is not null
            group by
                results."vendor_id"            
        ) return_vendor_id
            on(ap_supplier.VENDOR_ID = return_vendor_id."vendor_id") --##NEW## 03/10/2021
        order by
            ap_supplier.VENDOR_ID asc
    )
--select * from suppliers
,
    suppliers_ccna as (
        select
            18 as "ORDINAL_SORT"
            ,'SUPPLIERS_CCNA' as "DATA_GROUP"
            ,'EBS\Supplier Model\AP_SUPPLIERS\pos_bus_class_attr' as "DATA_SOURCE"            
            ,ap_supplier.VENDOR_ID as "column1" -- as "ebs_supplier_vendor_id"            
            ,ap_supplier.VENDOR_NAME as "column2" -- as "ebs_supplier_vendor_name"
            ,pos_bus_class_attr.LOOKUP_CODE as "column3" -- as "ebs_supplier_classification"
            ,pos_bus_class_attr.EXPIRATION_DATE as "column4" -- as "ebs_supplier_exp_dt"                           
        from AP_SUPPLIERS ap_supplier
        inner join (
            select
                "column1"
            from suppliers           
            group by "column1"           
        ) return_vendor_id
            on(ap_supplier.VENDOR_ID = return_vendor_id."column1")
        inner join pos_bus_class_attr
            on(
                ap_supplier.VENDOR_ID = pos_bus_class_attr.VENDOR_ID
                    and
                pos_bus_class_attr.lookup_code like '%CCNA%'    
            )
        order by
            ap_supplier.VENDOR_ID asc
    )
--select * from suppliers_ccna
,
    supplier_sites as (
        select
            19 as "ORDINAL_SORT"
            ,'SUPPLIER_SITES' as "DATA_GROUP"
            ,'EBS\Supplier Model\AP_SUPPLIER_SITES_ALL' as "DATA_SOURCE"            
            ,ap_supplier_site.VENDOR_ID as "column1" -- as "ebs_supp_site_vendor_id"
            ,ap_supplier_site.VENDOR_SITE_ID as "column2" -- as "ebs_supp_site_site_id"
            ,ap_supplier_site.VENDOR_SITE_CODE as "column3" -- as "ebs_supp_site_code"
            ,ap_supplier_site.PURCHASING_SITE_FLAG as "column4" -- as "ebs_supp_site_purch_flg"
            ,ap_supplier_site.ADDRESS_LINE1 as "column5" -- as "ebs_supp_site_addr_1"
            ,ap_supplier_site.ADDRESS_LINE2 as "column6" -- as "ebs_supp_site_addr_2"
            ,ap_supplier_site.CITY as "column7" -- as "ebs_supp_site_city"
            ,ap_supplier_site.STATE as "column8" -- as "ebs_supp_site_state"
            ,ap_supplier_site.ZIP as "column9" -- as "ebs_supp_site_zip"
            ,ap_supplier_site.PROVINCE as "column10" -- as "ebs_supp_site_prov"
            ,ap_supplier_site.COUNTRY as "column11" -- as "ebs_supp_site_cntry"
            ,ap_supplier_site.AREA_CODE as "column12" -- as "ebs_supp_site_area_code"
            ,ap_supplier_site.PHONE as "column13" -- as "ebs_supp_site_phone"
            ,ap_supplier_site.INACTIVE_DATE as "column14" -- as "ebs_supp_site_inactive_dt"                         
            ,ap_supplier_site.FAX as "column15" -- as "ebs_supp_site_fax"
            ,ap_supplier_site.FAX_AREA_CODE as "column16" -- as "ebs_supp_site_fax_area_code"
            ,ap_supplier_site.SUPPLIER_NOTIF_METHOD as "column17" -- as "ebs_supp_site_notif_meth"
            ,ap_supplier_site.EMAIL_ADDRESS as "column18" -- as "ebs_supp_site_email"
            ,ap_supplier_site.PARTY_SITE_ID as "column19" -- as "ebs_supp_site_party_site_id"

            ,ap_supplier_site.CREATION_DATE as "column49" -- as "ebs_supp_site_creation_dt"    
            ,ap_supplier_site.LAST_UPDATE_DATE as "column50" -- as "ebs_supp_site_update_dt"                        
        from AP_SUPPLIER_SITES_ALL ap_supplier_site
        inner join (
            select
                results."vendor_id"
                ,results."vendor_site_id"
            from (
                select
                    "column19" as "vendor_id"
                    ,"column20" as "vendor_site_id"
                from po_requisition_lines                
                union all
                select
                    "column11" as "vendor_id"
                    ,"column12" as "vendor_site_id"
                from ebs_po_headers                
                union all
                select
                    "column25" as "vendor_id"
                    ,"column26" as "vendor_site_id"
                from ebs_po_agreements                
                union all
                select
                    "column3" as "vendor_id"
                    ,"column5" as "vendor_site_id"
                from ebs_agr_pay_items                
                union all
                select
                    "column11" as "vendor_id"
                    ,"column12" as "vendor_site_id"
                from ebs_ap_inv_headers
                union all
                select
                    "column15" as "vendor_id"
                    ,"column16" as "vendor_site_id"
                from ap_inv_payments                                                                                                
            ) results
            where results."vendor_site_id" is not null
            group by
                results."vendor_id"
                ,results."vendor_site_id"            
        ) return_vendor_id
            on
                (
                    ap_supplier_site.ORG_ID = 102
                        and
                    ap_supplier_site.VENDOR_ID = return_vendor_id."vendor_id"
                        and
                    ap_supplier_site.VENDOR_SITE_ID = return_vendor_id."vendor_site_id"     
                )
        order by
            ap_supplier_site.VENDOR_ID asc
            ,ap_supplier_site.VENDOR_SITE_ID asc
    )
--select * from supplier_sites
,
    supplier_contacts as (
        select
            20 as "ORDINAL_SORT"
            ,'SUPPLIER_CONTACTS' as "DATA_GROUP"
            ,'EBS\Supplier Model\AP_SUPPLIER_CONTACTS' as "DATA_SOURCE"            
            ,ap_supplier_contact.VENDOR_CONTACT_ID as "column1" -- as "ebs_supp_con_vendor_id"
            ,ap_supplier_contact.VENDOR_SITE_ID as "column2" -- as "ebs_supp_con_site_id"
            ,ap_supplier_contact.INACTIVE_DATE as "column3" -- as "ebs_supp_con_inactive_dt"
            ,ap_supplier_contact.FIRST_NAME as "column4" -- as "ebs_supp_con_first_name"
            ,ap_supplier_contact.MIDDLE_NAME as "column5" -- as "ebs_supp_con_middle_name"
            ,ap_supplier_contact.LAST_NAME as "column6" -- as "ebs_supp_con_last_name"
            ,ap_supplier_contact.TITLE as "column7" -- as "ebs_supp_con_title"
            ,ap_supplier_contact.AREA_CODE as "column8" -- as "ebs_supp_con_area_code"
            ,ap_supplier_contact.PHONE as "column9" -- as "ebs_supp_con_phone"
            ,ap_supplier_contact.EMAIL_ADDRESS as "column10" -- as "ebs_supp_con_email"
            ,ap_supplier_contact.FIRST_NAME_ALT as "column11" -- as "ebs_supp_con_fname_alt"
            ,ap_supplier_contact.LAST_NAME_ALT as "column12" -- as "ebs_supp_con_lname_alt"
            ,ap_supplier_contact.ALT_AREA_CODE as "column13" -- as "ebs_supp_con_area_code_alt"
            ,ap_supplier_contact.ALT_PHONE as "column14" -- as "ebs_supp_con_phone_alt"                         
            ,ap_supplier_contact.FAX as "column15" -- as "ebs_supp_con_fax"
            ,ap_supplier_contact.FAX_AREA_CODE as "column16" -- as "ebs_supp_con_fax_area_code"
            ,ap_supplier_contact.URL as "column17" -- as "ebs_supp_con_url"
            ,ap_supplier_contact.PER_PARTY_ID as "column18" -- as "ebs_supp_con_per_party_id"
            ,ap_supplier_contact.RELATIONSHIP_ID as "column19" -- as "ebs_supp_con_relation_id"
            ,ap_supplier_contact.REL_PARTY_ID as "column20" -- as "ebs_supp_con_rel_party_id"
            ,ap_supplier_contact.PARTY_SITE_ID as "column21" -- as "ebs_supp_con_party_site_id"
            ,ap_supplier_contact.ORG_CONTACT_ID as "column22" -- as "ebs_supp_con_org_contact_id"
            ,ap_supplier_contact.ORG_PARTY_SITE_ID as "column23" -- as "ebs_supp_con_org_party_site_id"            

            ,ap_supplier_contact.CREATION_DATE as "column49" -- as "ebs_supp_con_create_dt"    
            ,ap_supplier_contact.LAST_UPDATE_DATE as "column50" -- as "ebs_supp_con_update_dt"                        
        from AP_SUPPLIER_CONTACTS ap_supplier_contact
        inner join supplier_sites
            on(ap_supplier_contact.ORG_PARTY_SITE_ID = supplier_sites."column2")
        order by
            ap_supplier_contact.VENDOR_SITE_ID asc
            ,ap_supplier_contact.VENDOR_CONTACT_ID asc
    )
--select * from supplier_contacts
,
    supplier_categories as (
        select
            21 as "ORDINAL_SORT"
            ,'SUPPLIER_CATEGORIES' as "DATA_GROUP"
            ,'EBS\Supplier Model\POS_SUP_PRODUCTS_SERVICES\MTL_CATEGORIES_VL' as "DATA_SOURCE"         
            ,pos_services.CLASSIFICATION_ID as "column1" -- as "ebs_supplier_cat_class_id"
            ,pos_services.VENDOR_ID as "column2" -- as "ebs_supplier_cat_vendor_id"
            ,pos_services.SEGMENT1 as "column3" -- as "ebs_supplier_cat_category"
            ,pos_services.SEGMENT2 as "column4" -- as "ebs_supplier_cat_sub_category"
            ,nvl(pos_services.SEGMENT1,'0')||'.'||nvl(pos_services.SEGMENT2,'0') as "column5" -- as "ebs_supplier_cat_category_code"
            ,pos_services.STATUS as "column6" -- as "ebs_supplier_cat_status"
            ,pos_services.SEGMENT_DEFINITION as "column7" -- as "ebs_supplier_cat_segment_definition"
            ,mtl_cat.CATEGORY_ID as "column8" -- as "ebs_supplier_cat_id"
            ,mtl_cat.STRUCTURE_ID as "column9" -- as "ebs_supplier_cat_structure_id"
            ,mtl_cat.SUMMARY_FLAG as "column10" -- as "ebs_supplier_cat_summary_flg"
            ,mtl_cat.ENABLED_FLAG as "column11" -- as "ebs_supplier_cat_enabled_flg"
            ,mtl_cat.DESCRIPTION as "column12" -- as "ebs_supplier_cat_description"
            ,pos_services.CREATION_DATE as "column49" -- as "ebs_supplier_cat_services_create_dt"
            ,pos_services.LAST_UPDATE_DATE as "column50" -- as "ebs_supplier_cat_services_update_dt"
        from suppliers
        inner join POS_SUP_PRODUCTS_SERVICES pos_services
            on(suppliers."column1" = pos_services.VENDOR_ID)
        inner join MTL_CATEGORIES_VL mtl_cat
            on
                (
                    pos_services.SEGMENT1 = mtl_cat.SEGMENT1
                        and
                    pos_services.SEGMENT2 = mtl_cat.SEGMENT2
                )
        order by
            pos_services.VENDOR_ID asc
            ,mtl_cat.CATEGORY_ID asc
            ,pos_services.CLASSIFICATION_ID
    )
--select * from supplier_categories
/*
,
       agreement_terms as (
            select
                22 as "ORDINAL_SORT"
                ,'AGREEMENT_TERMS' as "DATA_GROUP"
                ,'EBS\OKC Contracts\PON_AUCTION_HEADERS_ALL;OKC_K_ARTICLES_B;OKC_ARTICLES_ALL;OKC_ARTICLE_VERSIONS' as "DATA_SOURCE"                 
                ,ok_art_b.ID as "column1" --[EBS_TERMS_ID] [numeric](18, 0) PRIMARY KEY,
                ,ok_art_b.ORIG_ARTICLE_ID as "column2" --[EBS_TERMS_ORIG_ARTICLE_ID] [numeric](18, 0) NULL,
                ,ok_art_b.ARTICLE_VERSION_ID as "column3" --[EBS_TERMS_ARTICLE_VERSION_ID] [numeric](18, 0) NULL,
                ,auction_header_all.AUCTION_HEADER_ID as "column4" --[EBS_TERMS_AUCTION_HEADER_ID] [numeric](18, 0) NULL,
                ,auction_header_all.DOCUMENT_NUMBER as "column5" --[EBS_TERMS_AUCTION_BID_NO] [nvarchar](64) NULL, 
                ,ebs_po_agreements."column1" as "column6" --[EBS_TERMS_AGREEMENT_ID] [numeric](18, 0) NULL,
                ,ebs_po_agreements."column2" as "column7" --[EBS_TERMS_AGREEMENT_NO] [nvarchar](16) NULL,
                ,ok_art_b.DOCUMENT_TYPE as "column8" --[EBS_TERMS_DOCUMENT_TYPE] [nvarchar](64) NULL,
                ,ok_art_b.DOCUMENT_ID as "column9" --[EBS_TERMS_DOCUMENT_ID] [numeric](18, 0) NULL,
                ,ok_art_b.LABEL as "column10" --[EBS_TERMS_DISPLAY_LABEL] [nvarchar](16) NULL,
                ,ok_art_b.DISPLAY_SEQUENCE as "column11" --[EBS_TERMS_DISPLAY_SEQ] [numeric](18, 4) NULL,
                ,ok_art_all.ARTICLE_TITLE as "column12" --[EBS_TERMS_ARTICLE_TITLE] [nvarchar](512) NULL,
                ,ok_art_ver.ARTICLE_TEXT as "column13" --[EBS_TERMS_ARTICLE_TEXT] [nvarchar](max) NULL,
                ,ok_art_ver.CREATION_DATE as "column49" --[EBS_TERMS_CREATE_DT] [datetime] NULL,
                ,ok_art_ver.LAST_UPDATE_DATE as "column50" --[EBS_TERMS_UPDATE_DT] [datetime] NULL
            from ebs_po_agreements
            inner join PON_AUCTION_HEADERS_ALL auction_header_all
                on
                    (
                        ebs_po_agreements."column6" = auction_header_all.DOCUMENT_NUMBER
                            and
                        trunc(ebs_po_agreements."column8") >= trunc(SYSDATE)        
                    )
            inner join OKC_K_ARTICLES_B ok_art_b
                on(auction_header_all.AUCTION_HEADER_ID = ok_art_b.DOCUMENT_ID)
            inner join OKC_ARTICLES_ALL ok_art_all
                on
                    (
                        ok_art_b.ORIG_ARTICLE_ID = ok_art_all.ARTICLE_ID
                            and
                        ok_art_all.ARTICLE_ID like 'Allowance%'            
                    )
            inner join OKC_ARTICLE_VERSIONS ok_art_ver
                on(ok_art_b.ARTICLE_VERSION_ID = ok_art_ver.ARTICLE_VERSION_ID)       
            where 1=1
            order by
                ok_art_b.ID asc
                ,ok_art_b.ORIG_ARTICLE_ID asc
                ,ok_art_b.ARTICLE_VERSION_ID asc
                ,ebs_po_agreements."column1" asc
                ,auction_header_all.AUCTION_HEADER_ID asc
                ,ok_art_b.DOCUMENT_ID asc
                ,ok_art_b.DISPLAY_SEQUENCE asc           
       )
--select * from agreement_terms
*/

select
    ROW_NUMBER() OVER(
        ORDER BY null ASC
    ) as "ROWNUM"
    ,results.*
from (    
    Select
        ebs_pa_projects."ORDINAL_SORT"
        ,cast(ebs_pa_projects."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_pa_projects."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"
        ,cast(ebs_pa_projects."column1" as varchar2(2056)) as "column1"    
        ,cast(ebs_pa_projects."column2" as varchar2(2056)) as "column2"
        ,cast(ebs_pa_projects."column3" as varchar2(2056)) as "column3"
        ,cast(ebs_pa_projects."column4" as varchar2(2056)) as "column4"
        ,cast(ebs_pa_projects."column5" as varchar2(2056)) as "column5"
        ,cast(to_char(ebs_pa_projects."column6",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column6"
        ,cast(to_char(ebs_pa_projects."column7",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column7"
        ,cast(ebs_pa_projects."column8" as varchar2(2056)) as "column8"
        ,cast(ebs_pa_projects."column9" as varchar2(2056)) as "column9"
        ,cast(ebs_pa_projects."column10" as varchar2(2056)) as "column10"
        ,cast(ebs_pa_projects."column11" as varchar2(2056)) as "column11"
        ,cast(ebs_pa_projects."column12" as varchar2(2056)) as "column12"
        ,cast(ebs_pa_projects."column13" as varchar2(2056)) as "column13"
        ,cast(ebs_pa_projects."column14" as varchar2(2056)) as "column14"
        ,cast(ebs_pa_projects."column15" as varchar2(2056)) as "column15"
        ,cast(ebs_pa_projects."column16" as varchar2(2056)) as "column16"
        ,cast(ebs_pa_projects."column17" as varchar2(2056)) as "column17"
        ,cast(ebs_pa_projects."column18" as varchar2(2056)) as "column18"
        ,null as "column19"
        ,null as "column20"
        ,null as "column21"
        ,null as "column22"
        ,null as "column23"
        ,null as "column24"
        ,null as "column25"
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_pa_projects."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_pa_projects."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"    
    from ebs_pa_projects
        union all
    Select
        ebs_pa_tasks."ORDINAL_SORT"
        ,cast(ebs_pa_tasks."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_pa_tasks."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(ebs_pa_tasks."column1" as varchar2(2056)) as "column1"    
        ,cast(ebs_pa_tasks."column2" as varchar2(2056)) as "column2"
        ,cast(ebs_pa_tasks."column3" as varchar2(2056)) as "column3"
        ,cast(ebs_pa_tasks."column4" as varchar2(2056)) as "column4"
        ,cast(ebs_pa_tasks."column5" as varchar2(2056)) as "column5"
        ,cast(ebs_pa_tasks."column6" as varchar2(2056)) as "column6"
        ,cast(to_char(ebs_pa_tasks."column7",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column7"
        ,cast(to_char(ebs_pa_tasks."column8",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column8"
        ,cast(ebs_pa_tasks."column9" as varchar2(2056)) as "column9"
        ,cast(ebs_pa_tasks."column10" as varchar2(2056)) as "column10"
        ,cast(ebs_pa_tasks."column11" as varchar2(2056)) as "column11"
        ,cast(ebs_pa_tasks."column12" as varchar2(2056)) as "column12"
        ,cast(ebs_pa_tasks."column13" as varchar2(2056)) as "column13"
        ,null as "column14"
        ,null as "column15"
        ,null as "column16"
        ,null as "column17"
        ,null as "column18"
        ,null as "column19"
        ,null as "column20"
        ,null as "column21"
        ,null as "column22"
        ,null as "column23"
        ,null as "column24"
        ,null as "column25"
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_pa_tasks."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_pa_tasks."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"    
    from ebs_pa_tasks
        union all
    Select
        ebs_gms_awards."ORDINAL_SORT"
        ,cast(ebs_gms_awards."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_gms_awards."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"   
        ,cast(ebs_gms_awards."column1" as varchar2(2056)) as "column1"
        ,cast(ebs_gms_awards."column2" as varchar2(2056)) as "column2"
        ,cast(to_char(ebs_gms_awards."column3",'999999999.9999') as varchar2(2056)) as "column3"
        ,cast(ebs_gms_awards."column4" as varchar2(2056)) as "column4"
        ,cast(ebs_gms_awards."column5" as varchar2(2056)) as "column5"
        ,cast(ebs_gms_awards."column6" as varchar2(2056)) as "column6"
        ,cast(ebs_gms_awards."column7" as varchar2(2056)) as "column7"
        ,cast(ebs_gms_awards."column8" as varchar2(2056)) as "column8"
        ,cast(ebs_gms_awards."column9" as varchar2(2056)) as "column9"
        ,cast(to_char(ebs_gms_awards."column10",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column10"
        ,cast(to_char(ebs_gms_awards."column11",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column11"
        ,cast(to_char(ebs_gms_awards."column12",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column12"
        ,cast(ebs_gms_awards."column13" as varchar2(2056)) as "column13"
        ,cast(ebs_gms_awards."column14" as varchar2(2056)) as "column14"
        ,cast(ebs_gms_awards."column15" as varchar2(2056)) as "column15"
        ,cast(to_char(ebs_gms_awards."column16",'999999999.9999') as varchar2(2056))  as "column16"
        ,null as "column17"
        ,null as "column18"
        ,null as "column19"
        ,null as "column20"
        ,null as "column21"
        ,null as "column22"
        ,null as "column23"
        ,null as "column24"
        ,null as "column25"
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_gms_awards."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_gms_awards."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from ebs_gms_awards
        union all
    Select
        po_requisition_headers."ORDINAL_SORT"
        ,cast(po_requisition_headers."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(po_requisition_headers."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(po_requisition_headers."column1" as varchar2(2056)) as "column1"
        ,cast(po_requisition_headers."column2" as varchar2(2056)) as "column2"
        ,cast(po_requisition_headers."column3" as varchar2(2056)) as "column3"
        ,cast(po_requisition_headers."column4" as varchar2(2056)) as "column4"
        ,cast(po_requisition_headers."column5" as varchar2(2056)) as "column5"
        ,cast(po_requisition_headers."column6" as varchar2(2056)) as "column6"
        ,cast(po_requisition_headers."column7" as varchar2(2056)) as "column7"
        ,cast(to_char(po_requisition_headers."column8",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column8"
        ,null as "column9"
        ,null as "column10"
        ,null as "column11"
        ,null as "column12"
        ,null as "column13"
        ,null as "column14"
        ,null as "column15"
        ,null as "column16"
        ,null as "column17"
        ,null as "column18"
        ,null as "column19"
        ,null as "column20"
        ,null as "column21"
        ,null as "column22"
        ,null as "column23"
        ,null as "column24"
        ,null as "column25"
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(po_requisition_headers."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(po_requisition_headers."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from po_requisition_headers
        union all
    Select
        po_requisition_lines."ORDINAL_SORT"
        ,cast(po_requisition_lines."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(po_requisition_lines."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(po_requisition_lines."column1" as varchar2(2056)) as "column1"
        ,cast(po_requisition_lines."column2" as varchar2(2056)) as "column2"
        ,cast(po_requisition_lines."column3" as varchar2(2056)) as "column3"
        ,cast(po_requisition_lines."column4" as varchar2(2056)) as "column4"
        ,cast(po_requisition_lines."column5" as varchar2(2056)) as "column5"
        ,cast(to_char(po_requisition_lines."column6",'999999999.9999') as varchar2(2056)) as "column6"
        ,cast(to_char(po_requisition_lines."column7",'999999999.9999') as varchar2(2056)) as "column7"
        ,cast(to_char(po_requisition_lines."column8",'999999999.9999') as varchar2(2056)) as "column8"
        ,cast(to_char(po_requisition_lines."column9",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column9"
        ,cast(po_requisition_lines."column10" as varchar2(2056)) as "column10"
        ,cast(po_requisition_lines."column11" as varchar2(2056)) as "column11"
        ,cast(po_requisition_lines."column12" as varchar2(2056)) as "column12"
        ,cast(po_requisition_lines."column13" as varchar2(2056)) as "column13"
        ,cast(po_requisition_lines."column14" as varchar2(2056)) as "column14"
        ,cast(po_requisition_lines."column15" as varchar2(2056)) as "column15"
        ,cast(to_char(po_requisition_lines."column16",'999999999.9999') as varchar2(2056)) as "column16"
        ,cast(to_char(po_requisition_lines."column17",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column17"
        ,cast(po_requisition_lines."column18" as varchar2(2056)) as "column18"
        ,cast(po_requisition_lines."column19" as varchar2(2056)) as "column19"
        ,cast(po_requisition_lines."column20" as varchar2(2056)) as "column20"
        ,cast(po_requisition_lines."column21" as varchar2(2056)) as "column21"
        ,cast(po_requisition_lines."column22" as varchar2(2056)) as "column22"
        ,cast(po_requisition_lines."column23" as varchar2(2056)) as "column23"
        ,cast(po_requisition_lines."column24" as varchar2(2056)) as "column24"
        ,cast(po_requisition_lines."column25" as varchar2(2056)) as "column25"
        ,cast(po_requisition_lines."column26" as varchar2(2056)) as "column26"
        ,cast(to_char(po_requisition_lines."column27",'999999999.9999') as varchar2(2056)) as "column27"
        ,cast(po_requisition_lines."column28" as varchar2(2056)) as "column28"
        ,cast(to_char(po_requisition_lines."column29",'999999999.9999') as varchar2(2056)) as "column29"
        ,cast(po_requisition_lines."column30" as varchar2(2056)) as "column30" --##NEW## 03/13/2021
        ,cast(po_requisition_lines."column31" as varchar2(2056)) as "column31" --##NEW## 03/13/2021
        ,cast(po_requisition_lines."column32" as varchar2(2056)) as "column32" --##NEW## 03/13/2021
        ,cast(po_requisition_lines."column33" as varchar2(2056)) as "column33" --##NEW## 03/13/2021
        ,cast(po_requisition_lines."column34" as varchar2(2056)) as "column34" --##NEW## 03/13/2021
        ,cast(po_requisition_lines."column35" as varchar2(2056)) as "column35" --##NEW## 03/13/2021
        ,cast(po_requisition_lines."column36" as varchar2(2056)) as "column36" --##NEW## 03/13/2021
        ,cast(po_requisition_lines."column37" as varchar2(2056)) as "column37" --##NEW## 03/13/2021
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(po_requisition_lines."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(po_requisition_lines."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from po_requisition_lines
        union all
    Select
        po_requisition_dists."ORDINAL_SORT"
        ,cast(po_requisition_dists."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(po_requisition_dists."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(po_requisition_dists."column1" as varchar2(2056)) as "column1"
        ,cast(po_requisition_dists."column2" as varchar2(2056)) as "column2"
        ,cast(po_requisition_dists."column3" as varchar2(2056)) as "column3"
        ,cast(po_requisition_dists."column4" as varchar2(2056)) as "column4"
        ,cast(po_requisition_dists."column5" as varchar2(2056)) as "column5"
        ,cast(po_requisition_dists."column6" as varchar2(2056)) as "column6"
        ,cast(po_requisition_dists."column7" as varchar2(2056)) as "column7"
        ,cast(po_requisition_dists."column8" as varchar2(2056)) as "column8"
        ,cast(po_requisition_dists."column9" as varchar2(2056)) as "column9"
        ,cast(po_requisition_dists."column10" as varchar2(2056)) as "column10"
        ,cast(po_requisition_dists."column11" as varchar2(2056)) as "column11"
        ,cast(po_requisition_dists."column12" as varchar2(2056)) as "column12"
        ,cast(po_requisition_dists."column13" as varchar2(2056)) as "column13"
        ,cast(po_requisition_dists."column14" as varchar2(2056)) as "column14"
        ,cast(to_char(po_requisition_dists."column15",'999999999.9999') as varchar2(2056)) as "column15"
        ,cast(to_char(po_requisition_dists."column16",'999999999.9999') as varchar2(2056)) as "column16"
        ,cast(po_requisition_dists."column17" as varchar2(2056)) as "column17"
        ,cast(po_requisition_dists."column18" as varchar2(2056)) as "column18"
        ,cast(po_requisition_dists."column19" as varchar2(2056)) as "column19"
        ,cast(po_requisition_dists."column20" as varchar2(2056)) as "column20"
        ,cast(po_requisition_dists."column21" as varchar2(2056)) as "column21"
        ,cast(to_char(po_requisition_dists."column22",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column22"
        ,cast(to_char(po_requisition_dists."column23",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column23"
        ,cast(to_char(po_requisition_dists."column24",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column24"
        ,cast(to_char(po_requisition_dists."column25",'999999999.9999') as varchar2(2056)) as "column25"
        ,cast(po_requisition_dists."column26" as varchar2(2056)) as "column26"
        ,cast(po_requisition_dists."column27" as varchar2(2056)) as "column27"
        ,cast(po_requisition_dists."column28" as varchar2(2056)) as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(po_requisition_dists."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(po_requisition_dists."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from po_requisition_dists
        union all
    Select
        ebs_po_headers."ORDINAL_SORT"
        ,cast(ebs_po_headers."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_po_headers."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(ebs_po_headers."column1" as varchar2(2056)) as "column1"
        ,cast(ebs_po_headers."column2" as varchar2(2056)) as "column2"
        ,cast(ebs_po_headers."column3" as varchar2(2056)) as "column3"
        ,cast(ebs_po_headers."column4" as varchar2(2056)) as "column4"
        ,cast(to_char(ebs_po_headers."column5",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column5"
        ,cast(ebs_po_headers."column6" as varchar2(2056)) as "column6"
        ,cast(to_char(ebs_po_headers."column7",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column7"
        ,cast(ebs_po_headers."column8" as varchar2(2056)) as "column8"
        ,cast(ebs_po_headers."column9" as varchar2(2056)) as "column9"
        ,cast(to_char(ebs_po_headers."column10",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column10"
        ,cast(ebs_po_headers."column11" as varchar2(2056)) as "column11"
        ,cast(ebs_po_headers."column12" as varchar2(2056)) as "column12"
        ,cast(ebs_po_headers."column13" as varchar2(2056)) as "column13"
        ,cast(ebs_po_headers."column14" as varchar2(2056)) as "column14" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column15" as varchar2(2056)) as "column15" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column16" as varchar2(2056)) as "column16" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column17" as varchar2(2056)) as "column17" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column18" as varchar2(2056)) as "column18" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column19" as varchar2(2056)) as "column19" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column20" as varchar2(2056)) as "column20" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column21" as varchar2(2056)) as "column21" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column22" as varchar2(2056)) as "column22" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column23" as varchar2(2056)) as "column23" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column24" as varchar2(2056)) as "column24" --##NEW## 03/10/2021
        ,cast(ebs_po_headers."column25" as varchar2(2056)) as "column25" --##NEW## 03/10/2021
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_po_headers."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_po_headers."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from ebs_po_headers
        union all
    Select
        ebs_po_lines."ORDINAL_SORT"
        ,cast(ebs_po_lines."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_po_lines."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(ebs_po_lines."column1" as varchar2(2056)) as "column1"
        ,cast(ebs_po_lines."column2" as varchar2(2056)) as "column2"
        ,cast(ebs_po_lines."column3" as varchar2(2056)) as "column3"
        ,cast(ebs_po_lines."column4" as varchar2(2056)) as "column4"
        ,cast(ebs_po_lines."column5" as varchar2(2056)) as "column5"
        ,cast(ebs_po_lines."column6" as varchar2(2056)) as "column6"
        ,cast(ebs_po_lines."column7" as varchar2(2056)) as "column7"
        ,cast(to_char(ebs_po_lines."column8",'999999999.9999') as varchar2(2056)) as "column8"
        ,cast(ebs_po_lines."column9" as varchar2(2056)) as "column9"
        ,cast(to_char(ebs_po_lines."column10",'999999999.9999') as varchar2(2056)) as "column10"
        ,cast(to_char(ebs_po_lines."column11",'999999999.9999') as varchar2(2056)) as "column11"
        ,cast(ebs_po_lines."column12" as varchar2(2056)) as "column12"
        ,cast(to_char(ebs_po_lines."column13",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column13"
        ,cast(ebs_po_lines."column14" as varchar2(2056)) as "column14"
        ,cast(to_char(ebs_po_lines."column15",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column15"
        ,cast(ebs_po_lines."column16" as varchar2(2056)) as "column16"
        ,cast(to_char(ebs_po_lines."column17",'999999999.9999') as varchar2(2056)) as "column17"
        ,cast(ebs_po_lines."column18" as varchar2(2056)) as "column18" --##NEW## 03/10/2021
        ,cast(ebs_po_lines."column19" as varchar2(2056)) as "column19" --##NEW## 03/10/2021
        ,cast(ebs_po_lines."column20" as varchar2(2056)) as "column20" --##NEW## 03/10/2021
        ,cast(ebs_po_lines."column21" as varchar2(2056)) as "column21" --##NEW## 03/10/2021
        ,cast(ebs_po_lines."column22" as varchar2(2056)) as "column22" --##NEW## 03/13/2021
        ,cast(ebs_po_lines."column23" as varchar2(2056)) as "column23" --##NEW## 03/13/2021
        ,cast(ebs_po_lines."column24" as varchar2(2056)) as "column24" --##NEW## 03/13/2021
        ,cast(ebs_po_lines."column25" as varchar2(2056)) as "column25" --##NEW## 03/13/2021
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_po_lines."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_po_lines."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from ebs_po_lines
        union all
    Select
        ebs_po_dist."ORDINAL_SORT"
        ,cast(ebs_po_dist."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_po_dist."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(ebs_po_dist."column1" as varchar2(2056)) as "column1"
        ,cast(ebs_po_dist."column2" as varchar2(2056)) as "column2"
        ,cast(ebs_po_dist."column3" as varchar2(2056)) as "column3"
        ,cast(ebs_po_dist."column4" as varchar2(2056)) as "column4"
        ,cast(ebs_po_dist."column5" as varchar2(2056)) as "column5"
        ,cast(ebs_po_dist."column6" as varchar2(2056)) as "column6"
        ,cast(ebs_po_dist."column7" as varchar2(2056)) as "column7"
        ,cast(ebs_po_dist."column8" as varchar2(2056)) as "column8"
        ,cast(ebs_po_dist."column9" as varchar2(2056)) as "column9"
        ,cast(ebs_po_dist."column10" as varchar2(2056)) as "column10"
        ,cast(ebs_po_dist."column11" as varchar2(2056)) as "column11"
        ,cast(ebs_po_dist."column12" as varchar2(2056)) as "column12"
        ,cast(ebs_po_dist."column13" as varchar2(2056)) as "column13"
        ,cast(ebs_po_dist."column14" as varchar2(2056)) as "column14"
        ,cast(to_char(ebs_po_dist."column15",'999999999.9999') as varchar2(2056)) as "column15"
        ,cast(to_char(ebs_po_dist."column16",'999999999.9999') as varchar2(2056)) as "column16"
        ,cast(to_char(ebs_po_dist."column17",'999999999.9999') as varchar2(2056)) as "column17"
        ,cast(to_char(ebs_po_dist."column18",'999999999.9999') as varchar2(2056)) as "column18"
        ,cast(to_char(ebs_po_dist."column19",'999999999.9999') as varchar2(2056)) as "column19"
        ,cast(to_char(ebs_po_dist."column20",'999999999.9999') as varchar2(2056)) as "column20"
        ,cast(to_char(ebs_po_dist."column21",'999999999.9999') as varchar2(2056)) as "column21"
        ,cast(to_char(ebs_po_dist."column22",'999999999.9999') as varchar2(2056)) as "column22"
        ,cast(to_char(ebs_po_dist."column23",'999999999.9999') as varchar2(2056)) as "column23"
        ,cast(to_char(ebs_po_dist."column24",'999999999.9999') as varchar2(2056)) as "column24"
        ,cast(to_char(ebs_po_dist."column25",'999999999.9999') as varchar2(2056)) as "column25"
        ,cast(to_char(ebs_po_dist."column26",'999999999.9999') as varchar2(2056)) as "column26"
        ,cast(to_char(ebs_po_dist."column27",'999999999.9999') as varchar2(2056)) as "column27"
        ,cast(to_char(ebs_po_dist."column28",'999999999.9999') as varchar2(2056)) as "column28"
        ,cast(to_char(ebs_po_dist."column29",'999999999.9999') as varchar2(2056)) as "column29"
        ,cast(ebs_po_dist."column30" as varchar2(2056)) as "column30"
        ,cast(ebs_po_dist."column31" as varchar2(2056)) as "column31"
        ,cast(ebs_po_dist."column32" as varchar2(2056)) as "column32"
        ,cast(ebs_po_dist."column33" as varchar2(2056)) as "column33"
        ,cast(ebs_po_dist."column34" as varchar2(2056)) as "column34"
        ,cast(ebs_po_dist."column35" as varchar2(2056)) as "column35"
        ,cast(ebs_po_dist."column36" as varchar2(2056)) as "column36"
        ,cast(ebs_po_dist."column37" as varchar2(2056)) as "column37"
        ,cast(ebs_po_dist."column38" as varchar2(2056)) as "column38" --##NEW## 03/10/2021
        ,cast(to_char(ebs_po_dist."column39",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column39" --##NEW## 03/10/2021
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_po_dist."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_po_dist."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from ebs_po_dist
        union all
    Select
        ebs_po_agreements."ORDINAL_SORT"
        ,cast(ebs_po_agreements."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_po_agreements."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(ebs_po_agreements."column1" as varchar2(2056)) as "column1"
        ,cast(ebs_po_agreements."column2" as varchar2(2056)) as "column2"
        ,cast(ebs_po_agreements."column3" as varchar2(2056)) as "column3"
        ,cast(ebs_po_agreements."column4" as varchar2(2056)) as "column4"
        ,cast(ebs_po_agreements."column5" as varchar2(2056)) as "column5"
        ,cast(ebs_po_agreements."column6" as varchar2(2056)) as "column6"
        ,cast(to_char(ebs_po_agreements."column7",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column7"
        ,cast(to_char(ebs_po_agreements."column8",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column8"
        ,cast(ebs_po_agreements."column9" as varchar2(2056)) as "column9"
        ,cast(ebs_po_agreements."column10" as varchar2(2056)) as "column10"
        ,cast(ebs_po_agreements."column11" as varchar2(2056)) as "column11"
        ,cast(ebs_po_agreements."column12" as varchar2(2056)) as "column12"
        ,cast(ebs_po_agreements."column13" as varchar2(2056)) as "column13"
        ,cast(ebs_po_agreements."column14" as varchar2(2056)) as "column14"
        ,cast(to_char(ebs_po_agreements."column15",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column15"
        ,cast(ebs_po_agreements."column16" as varchar2(2056)) as "column16"
        ,cast(ebs_po_agreements."column17" as varchar2(2056)) as "column17"
        ,cast(ebs_po_agreements."column18" as varchar2(2056)) as "column18"
        ,cast(to_char(ebs_po_agreements."column19",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column19"
        ,cast(ebs_po_agreements."column20" as varchar2(2056)) as "column20"
        ,cast(ebs_po_agreements."column21" as varchar2(2056)) as "column21"
        ,cast(ebs_po_agreements."column22" as varchar2(2056)) as "column22"
        ,cast(ebs_po_agreements."column23" as varchar2(2056)) as "column23"
        ,cast(to_char(ebs_po_agreements."column24",'999999999.9999') as varchar2(2056)) as "column24"
        ,cast(ebs_po_agreements."column25" as varchar2(2056)) as "column25"
        ,cast(ebs_po_agreements."column26" as varchar2(2056)) as "column26"
        ,cast(ebs_po_agreements."column27" as varchar2(2056)) as "column27"
        ,cast(ebs_po_agreements."column28" as varchar2(2056)) as "column28"
        ,cast(ebs_po_agreements."column29" as varchar2(2056)) as "column29"
        ,cast(ebs_po_agreements."column30" as varchar2(2056)) as "column30" --##NEW## 3/10/2021
        ,cast(ebs_po_agreements."column31" as varchar2(2056)) as "column31" --##NEW## 3/10/2021
        ,cast(ebs_po_agreements."column32" as varchar2(2056)) as "column32" --##NEW## 3/10/2021
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_po_agreements."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_po_agreements."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from ebs_po_agreements
        union all
    Select
        ebs_auction_header."ORDINAL_SORT"
        ,cast(ebs_auction_header."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_auction_header."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(ebs_auction_header."column1" as varchar2(2056)) as "column1"
        ,cast(ebs_auction_header."column2" as varchar2(2056)) as "column2"
        ,cast(ebs_auction_header."column3" as varchar2(2056)) as "column3"
        ,cast(ebs_auction_header."column4" as varchar2(2056)) as "column4"
        ,cast(ebs_auction_header."column5" as varchar2(2056)) as "column5"
        ,cast(ebs_auction_header."column6" as varchar2(2056)) as "column6"
        ,cast(ebs_auction_header."column7" as varchar2(2056)) as "column7"
        ,cast(ebs_auction_header."column8" as varchar2(2056)) as "column8"
        ,cast(ebs_auction_header."column9" as varchar2(2056)) as "column9"
        ,cast(to_char(ebs_auction_header."column10",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column10"
        ,cast(to_char(ebs_auction_header."column11",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column11"
        ,cast(ebs_auction_header."column12" as varchar2(2056)) as "column12"
        ,cast(to_char(ebs_auction_header."column13",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column13"
        ,cast(to_char(ebs_auction_header."column14",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column14"
        ,cast(ebs_auction_header."column15" as varchar2(2056)) as "column15"
        ,cast(ebs_auction_header."column16" as varchar2(2056)) as "column16"
        ,cast(ebs_auction_header."column17" as varchar2(2056)) as "column17"
        ,cast(ebs_auction_header."column18" as varchar2(2056)) as "column18"
        ,cast(ebs_auction_header."column19" as varchar2(2056)) as "column19"
        ,cast(ebs_auction_header."column20" as varchar2(2056)) as "column20"
        ,null as "column21"
        ,null as "column22"
        ,null as "column23"
        ,null as "column24"
        ,null as "column25"
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_auction_header."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_auction_header."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from ebs_auction_header
        union all        
    Select
        ebs_agr_pay_items."ORDINAL_SORT"
        ,cast(ebs_agr_pay_items."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_agr_pay_items."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(ebs_agr_pay_items."column1" as varchar2(2056)) as "column1"
        ,cast(ebs_agr_pay_items."column2" as varchar2(2056)) as "column2"
        ,cast(ebs_agr_pay_items."column3" as varchar2(2056)) as "column3"
        ,cast(ebs_agr_pay_items."column4" as varchar2(2056)) as "column4"
        ,cast(ebs_agr_pay_items."column5" as varchar2(2056)) as "column5"
        ,cast(ebs_agr_pay_items."column6" as varchar2(2056)) as "column6"
        ,cast(ebs_agr_pay_items."column7" as varchar2(2056)) as "column7"
        ,cast(ebs_agr_pay_items."column8" as varchar2(2056)) as "column8"
        ,cast(ebs_agr_pay_items."column9" as varchar2(2056)) as "column9"
        ,cast(ebs_agr_pay_items."column10" as varchar2(2056)) as "column10"
        ,cast(ebs_agr_pay_items."column11" as varchar2(2056)) as "column11"
        ,cast(ebs_agr_pay_items."column12" as varchar2(2056)) as "column12"
        ,cast(ebs_agr_pay_items."column13" as varchar2(2056)) as "column13"
        ,cast(ebs_agr_pay_items."column14" as varchar2(2056)) as "column14"
        ,cast(ebs_agr_pay_items."column15" as varchar2(2056)) as "column15"
        ,cast(to_char(ebs_agr_pay_items."column16",'999999999.9999') as varchar2(2056)) as "column16"
        ,cast(ebs_agr_pay_items."column17" as varchar2(2056)) as "column17"
        ,cast(ebs_agr_pay_items."column18" as varchar2(2056)) as "column18"
        ,cast(to_char(ebs_agr_pay_items."column19",'999999999.9999') as varchar2(2056)) as "column19"   
        ,cast(ebs_agr_pay_items."column20" as varchar2(2056)) as "column20"
        ,null as "column21" --##NEW## 03/10/2021    
        ,cast(ebs_agr_pay_items."column22" as varchar2(2056)) as "column22" --##NEW## 03/10/2021
        ,cast(ebs_agr_pay_items."column23" as varchar2(2056)) as "column23" --##NEW## 03/10/2021
        ,cast(ebs_agr_pay_items."column24" as varchar2(2056)) as "column24" --##NEW## 03/10/2021
        ,cast(ebs_agr_pay_items."column25" as varchar2(2056)) as "column25" --##NEW## 03/10/2021
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_agr_pay_items."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_agr_pay_items."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from ebs_agr_pay_items    
        union all
    Select
        ebs_ap_inv_headers."ORDINAL_SORT"
        ,cast(ebs_ap_inv_headers."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_ap_inv_headers."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(ebs_ap_inv_headers."column1" as varchar2(2056)) as "column1"
        ,cast(ebs_ap_inv_headers."column2" as varchar2(2056)) as "column2"
        ,cast(ebs_ap_inv_headers."column3" as varchar2(2056)) as "column3"
        ,cast(to_char(ebs_ap_inv_headers."column4",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column4"
        ,cast(to_char(ebs_ap_inv_headers."column5",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column5"
        ,cast(to_char(ebs_ap_inv_headers."column6",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column6"
        ,cast(to_char(ebs_ap_inv_headers."column7",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column7"
        ,cast(to_char(ebs_ap_inv_headers."column8",'999999999.9999') as varchar2(2056)) as "column8"
        ,cast(to_char(ebs_ap_inv_headers."column9",'999999999.9999') as varchar2(2056)) as "column9"
        ,cast(ebs_ap_inv_headers."column10" as varchar2(2056)) as "column10"
        ,cast(ebs_ap_inv_headers."column11" as varchar2(2056)) as "column11"
        ,cast(ebs_ap_inv_headers."column12" as varchar2(2056)) as "column12"
        ,cast(ebs_ap_inv_headers."column13" as varchar2(2056)) as "column13"
        ,cast(ebs_ap_inv_headers."column14" as varchar2(2056)) as "column14"
        ,cast(ebs_ap_inv_headers."column15" as varchar2(2056)) as "column15"
        ,cast(ebs_ap_inv_headers."column16" as varchar2(2056)) as "column16"
        ,cast(to_char(ebs_ap_inv_headers."column17",'999999999.9999') as varchar2(2056)) as "column17"
        ,cast(to_char(ebs_ap_inv_headers."column18",'999999999.9999') as varchar2(2056)) as "column18"
        ,cast(ebs_ap_inv_headers."column19" as varchar2(2056)) as "column19"
        ,cast(ebs_ap_inv_headers."column20" as varchar2(2056)) as "column20"
        ,null as "column21"
        ,null as "column22"
        ,null as "column23"
        ,null as "column24"
        ,null as "column25"
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_ap_inv_headers."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_ap_inv_headers."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from ebs_ap_inv_headers
        union all
    Select
        ebs_ap_inv_lines."ORDINAL_SORT"
        ,cast(ebs_ap_inv_lines."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_ap_inv_lines."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(ebs_ap_inv_lines."column1" as varchar2(2056)) as "column1"
        ,cast(ebs_ap_inv_lines."column2" as varchar2(2056)) as "column2"
        ,cast(ebs_ap_inv_lines."column3" as varchar2(2056)) as "column3"
        ,cast(ebs_ap_inv_lines."column4" as varchar2(2056)) as "column4"
        ,cast(ebs_ap_inv_lines."column5" as varchar2(2056)) as "column5"
        ,cast(ebs_ap_inv_lines."column6" as varchar2(2056)) as "column6"
        ,cast(ebs_ap_inv_lines."column7" as varchar2(2056)) as "column7"
        ,cast(to_char(ebs_ap_inv_lines."column8",'999999999.9999') as varchar2(2056)) as "column8"
        ,cast(ebs_ap_inv_lines."column9" as varchar2(2056)) as "column9"
        ,cast(to_char(ebs_ap_inv_lines."column10",'999999999.9999') as varchar2(2056)) as "column10"
        ,cast(ebs_ap_inv_lines."column11" as varchar2(2056)) as "column11"
        ,cast(ebs_ap_inv_lines."column12" as varchar2(2056)) as "column12"
        ,cast(ebs_ap_inv_lines."column13" as varchar2(2056)) as "column13"
        ,cast(ebs_ap_inv_lines."column14" as varchar2(2056)) as "column14"
        ,cast(ebs_ap_inv_lines."column15" as varchar2(2056)) as "column15"
        ,cast(ebs_ap_inv_lines."column16" as varchar2(2056)) as "column16"
        ,cast(ebs_ap_inv_lines."column17" as varchar2(2056)) as "column17"
        ,cast(ebs_ap_inv_lines."column18" as varchar2(2056)) as "column18"
        ,cast(ebs_ap_inv_lines."column19" as varchar2(2056)) as "column19"
        ,cast(to_char(ebs_ap_inv_lines."column20",'999999999.9999') as varchar2(2056)) as "column20" --##NEW## 04/04/2021 
        ,null as "column21"
        ,null as "column22"
        ,null as "column23"
        ,null as "column24"
        ,null as "column25"
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_ap_inv_lines."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_ap_inv_lines."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from ebs_ap_inv_lines
        union all
    Select
        ebs_ap_inv_dists."ORDINAL_SORT"
        ,cast(ebs_ap_inv_dists."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ebs_ap_inv_dists."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(ebs_ap_inv_dists."column1" as varchar2(2056)) as "column1"
        ,cast(ebs_ap_inv_dists."column2" as varchar2(2056)) as "column2"
        ,cast(ebs_ap_inv_dists."column3" as varchar2(2056)) as "column3"
        ,cast(ebs_ap_inv_dists."column4" as varchar2(2056)) as "column4"
        ,cast(ebs_ap_inv_dists."column5" as varchar2(2056)) as "column5"
        ,cast(ebs_ap_inv_dists."column6" as varchar2(2056)) as "column6"
        ,cast(ebs_ap_inv_dists."column7" as varchar2(2056)) as "column7"
        ,cast(ebs_ap_inv_dists."column8" as varchar2(2056)) as "column8"
        ,cast(ebs_ap_inv_dists."column9" as varchar2(2056)) as "column9"
        ,cast(to_char(ebs_ap_inv_dists."column10",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column10"
        ,cast(to_char(ebs_ap_inv_dists."column11",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column11"
        ,cast(ebs_ap_inv_dists."column12" as varchar2(2056)) as "column12"
        ,cast(ebs_ap_inv_dists."column13" as varchar2(2056)) as "column13"
        ,cast(ebs_ap_inv_dists."column14" as varchar2(2056)) as "column14"
        ,cast(ebs_ap_inv_dists."column15" as varchar2(2056)) as "column15"
        ,cast(ebs_ap_inv_dists."column16" as varchar2(2056)) as "column16"
        ,cast(to_char(ebs_ap_inv_dists."column17",'999999999.9999') as varchar2(2056)) as "column17"
        ,cast(to_char(ebs_ap_inv_dists."column18",'999999999.9999') as varchar2(2056)) as "column18"
        ,cast(to_char(ebs_ap_inv_dists."column19",'999999999.9999') as varchar2(2056)) as "column19"
        ,cast(to_char(ebs_ap_inv_dists."column20",'999999999.9999') as varchar2(2056)) as "column20"
        ,cast(to_char(ebs_ap_inv_dists."column21",'999999999.9999') as varchar2(2056)) as "column21"
        ,cast(ebs_ap_inv_dists."column22" as varchar2(2056)) as "column22"
        ,cast(ebs_ap_inv_dists."column23" as varchar2(2056)) as "column23"
        ,cast(ebs_ap_inv_dists."column24" as varchar2(2056)) as "column24"
        ,cast(ebs_ap_inv_dists."column25" as varchar2(2056)) as "column25"
        ,cast(ebs_ap_inv_dists."column26" as varchar2(2056)) as "column26"
        ,cast(ebs_ap_inv_dists."column27" as varchar2(2056)) as "column27"
        ,cast(ebs_ap_inv_dists."column28" as varchar2(2056)) as "column28"
        ,cast(ebs_ap_inv_dists."column29" as varchar2(2056)) as "column29"
        ,cast(ebs_ap_inv_dists."column30" as varchar2(2056)) as "column30"
        ,cast(ebs_ap_inv_dists."column31" as varchar2(2056)) as "column31"
        ,cast(ebs_ap_inv_dists."column32" as varchar2(2056)) as "column32"
        ,cast(ebs_ap_inv_dists."column33" as varchar2(2056)) as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ebs_ap_inv_dists."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ebs_ap_inv_dists."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from ebs_ap_inv_dists
        union all
    Select
        ap_inv_payments."ORDINAL_SORT"
        ,cast(ap_inv_payments."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(ap_inv_payments."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"            
        ,cast(ap_inv_payments."column1" as varchar2(2056)) as "column1"
        ,cast(ap_inv_payments."column2" as varchar2(2056)) as "column2"
        ,cast(ap_inv_payments."column3" as varchar2(2056)) as "column3"
        ,cast(ap_inv_payments."column4" as varchar2(2056)) as "column4"
        ,cast(ap_inv_payments."column5" as varchar2(2056)) as "column5"
        ,cast(ap_inv_payments."column6" as varchar2(2056)) as "column6"
        ,cast(ap_inv_payments."column7" as varchar2(2056)) as "column7"
        --,cast(ap_inv_payments."column8" as varchar2(2056)) as "column8"  --##NEW## 03/13/2021 REMOVED, COLUMN REALIGNMENT
        ,cast(to_char(ap_inv_payments."column8",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column8"  --##NEW## 03/13/2021 REMOVED, COLUMN REALIGNMENT        
        ,cast(to_char(ap_inv_payments."column9",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column9"  --##NEW## 03/13/2021 REMOVED, COLUMN REALIGNMENT
        --,cast(to_char(ap_inv_payments."column10",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column10"  --##NEW## 03/13/2021 REMOVED, COLUMN REALIGNMENT
        ,cast(to_char(ap_inv_payments."column10",'999999999.9999') as varchar2(2056)) as "column10"  --##NEW## 03/13/2021 REMOVED, COLUMN REALIGNMENT        
        --,cast(to_char(ap_inv_payments."column11",'999999999.9999') as varchar2(2056)) as "column11"  --##NEW## 03/13/2021 REMOVED, COLUMN REALIGNMENT
        ,cast(ap_inv_payments."column11" as varchar2(2056)) as "column11"  --##NEW## 03/13/2021 REMOVED, COLUMN REALIGNMENT        
        --,cast(ap_inv_payments."column12" as varchar2(2056)) as "column12"  --##NEW## 03/13/2021 REMOVED, COLUMN REALIGNMENT
        ,cast(to_char(ap_inv_payments."column12",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column12"  --##NEW## 03/13/2021 REMOVED, COLUMN REALIGNMENT        
        --,cast(to_char(ap_inv_payments."column13",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column13"  --##NEW## 03/13/2021 REMOVED, COLUMN REALIGNMENT
        ,cast(ap_inv_payments."column13" as varchar2(2056)) as "column13"        
        ,cast(ap_inv_payments."column14" as varchar2(2056)) as "column14"
        ,cast(ap_inv_payments."column15" as varchar2(2056)) as "column15"
        ,cast(ap_inv_payments."column16" as varchar2(2056)) as "column16"
        --,cast(ap_inv_payments."column17" as varchar2(2056)) as "column17"  --##NEW## 03/13/2021 REMOVED, COLUMN REALIGNMENT
        ,null as "column17"
        ,null as "column18"
        ,null as "column19"
        ,null as "column20"
        ,null as "column21"
        ,null as "column22"
        ,null as "column23"
        ,null as "column24"
        ,null as "column25"
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(ap_inv_payments."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(ap_inv_payments."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from ap_inv_payments
        union all
    Select
        suppliers."ORDINAL_SORT"
        ,cast(suppliers."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(suppliers."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(suppliers."column1" as varchar2(2056)) as "column1"
        ,cast(suppliers."column2" as varchar2(2056)) as "column2"
        ,cast(to_char(suppliers."column3",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column3"
        ,cast(to_char(suppliers."column4",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column4"
        ,cast(suppliers."column5" as varchar2(2056)) as "column5"
        ,cast(suppliers."column6" as varchar2(2056)) as "column6"
        ,cast(suppliers."column7" as varchar2(2056)) as "column7"
        ,cast(suppliers."column8" as varchar2(2056)) as "column8"
        ,cast(suppliers."column9" as varchar2(2056)) as "column9"
        ,cast(suppliers."column10" as varchar2(2056)) as "column10"
        ,cast(suppliers."column11" as varchar2(2056)) as "column11"
        ,null as "column12"
        ,null as "column13"
        ,null as "column14"
        ,null as "column15"
        ,null as "column16"
        ,null as "column17"
        ,null as "column18"
        ,null as "column19"
        ,null as "column20"
        ,null as "column21"
        ,null as "column22"
        ,null as "column23"
        ,null as "column24"
        ,null as "column25"
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(suppliers."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(suppliers."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from suppliers
        union all
    Select
        suppliers_ccna."ORDINAL_SORT"
        ,cast(suppliers_ccna."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(suppliers_ccna."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(suppliers_ccna."column1" as varchar2(2056)) as "column1"
        ,cast(suppliers_ccna."column2" as varchar2(2056)) as "column2"
        ,cast(suppliers_ccna."column3" as varchar2(2056)) as "column3"
        ,cast(suppliers_ccna."column4" as varchar2(2056)) as "column4"
        ,null as "column5"
        ,null as "column6"
        ,null as "column7"
        ,null as "column8"
        ,null as "column9"
        ,null as "column10"
        ,null as "column11"
        ,null as "column12"
        ,null as "column13"
        ,null as "column14"
        ,null as "column15"
        ,null as "column16"
        ,null as "column17"
        ,null as "column18"
        ,null as "column19"
        ,null as "column20"
        ,null as "column21"
        ,null as "column22"
        ,null as "column23"
        ,null as "column24"
        ,null as "column25"
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,null as "column49"
        ,null as "column50"
    from suppliers_ccna
        union all
    Select
        supplier_sites."ORDINAL_SORT"   
        ,cast(supplier_sites."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(supplier_sites."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(supplier_sites."column1" as varchar2(2056)) as "column1"
        ,cast(supplier_sites."column2" as varchar2(2056)) as "column2"
        ,cast(supplier_sites."column3" as varchar2(2056)) as "column3"
        ,cast(supplier_sites."column4" as varchar2(2056)) as "column4"
        ,cast(supplier_sites."column5" as varchar2(2056)) as "column5"
        ,cast(supplier_sites."column6" as varchar2(2056)) as "column6"
        ,cast(supplier_sites."column7" as varchar2(2056)) as "column7"
        ,cast(supplier_sites."column8" as varchar2(2056)) as "column8"
        ,cast(supplier_sites."column9" as varchar2(2056)) as "column9"
        ,cast(supplier_sites."column10" as varchar2(2056)) as "column10"
        ,cast(supplier_sites."column11" as varchar2(2056)) as "column11"
        ,cast(supplier_sites."column12" as varchar2(2056)) as "column12"
        ,cast(supplier_sites."column13" as varchar2(2056)) as "column13"
        ,cast(to_char(supplier_sites."column14",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column14"
        ,cast(supplier_sites."column15" as varchar2(2056)) as "column15"
        ,cast(supplier_sites."column16" as varchar2(2056)) as "column16"
        ,cast(supplier_sites."column17" as varchar2(2056)) as "column17"
        ,cast(supplier_sites."column18" as varchar2(2056)) as "column18"
        ,cast(supplier_sites."column19" as varchar2(2056)) as "column19"
        ,null as "column20"
        ,null as "column21"
        ,null as "column22"
        ,null as "column23"
        ,null as "column24"
        ,null as "column25"
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(supplier_sites."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(supplier_sites."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from supplier_sites
        union all
    Select
        supplier_contacts."ORDINAL_SORT"
        ,cast(supplier_contacts."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(supplier_contacts."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(supplier_contacts."column1" as varchar2(2056)) as "column1"
        ,cast(supplier_contacts."column2" as varchar2(2056)) as "column2"
        ,cast(supplier_contacts."column3" as varchar2(2056)) as "column3"
        ,cast(supplier_contacts."column4" as varchar2(2056)) as "column4"
        ,cast(supplier_contacts."column5" as varchar2(2056)) as "column5"
        ,cast(supplier_contacts."column6" as varchar2(2056)) as "column6"
        ,cast(supplier_contacts."column7" as varchar2(2056)) as "column7"
        ,cast(supplier_contacts."column8" as varchar2(2056)) as "column8"
        ,cast(supplier_contacts."column9" as varchar2(2056)) as "column9"
        ,cast(supplier_contacts."column10" as varchar2(2056)) as "column10"
        ,cast(supplier_contacts."column11" as varchar2(2056)) as "column11"
        ,cast(supplier_contacts."column12" as varchar2(2056)) as "column12"
        ,cast(supplier_contacts."column13" as varchar2(2056)) as "column13"
        ,cast(supplier_contacts."column14" as varchar2(2056)) as "column14"
        ,cast(supplier_contacts."column15" as varchar2(2056)) as "column15"
        ,cast(supplier_contacts."column16" as varchar2(2056)) as "column16"
        ,cast(supplier_contacts."column17" as varchar2(2056)) as "column17"
        ,cast(supplier_contacts."column18" as varchar2(2056)) as "column18"
        ,cast(supplier_contacts."column19" as varchar2(2056)) as "column19"
        ,cast(supplier_contacts."column20" as varchar2(2056)) as "column20"
        ,cast(supplier_contacts."column21" as varchar2(2056)) as "column21"
        ,cast(supplier_contacts."column22" as varchar2(2056)) as "column22"
        ,cast(supplier_contacts."column23" as varchar2(2056)) as "column23"
        ,null as "column24"
        ,null as "column25"
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(supplier_contacts."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(supplier_contacts."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"
    from supplier_contacts
        union all
     --##NEW## 03/10/2021
    Select
        supplier_categories."ORDINAL_SORT"
        ,cast(supplier_categories."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(supplier_categories."DATA_SOURCE" as varchar2(256)) as "DATA_SOURCE"    
        ,cast(supplier_categories."column1" as varchar2(2056)) as "column1"    
        ,cast(supplier_categories."column2" as varchar2(2056)) as "column2"
        ,cast(supplier_categories."column3" as varchar2(2056)) as "column3"
        ,cast(supplier_categories."column4" as varchar2(2056)) as "column4"
        ,cast(supplier_categories."column5" as varchar2(2056)) as "column5"
        ,cast(supplier_categories."column6" as varchar2(2056)) as "column6"
        ,cast(supplier_categories."column7" as varchar2(2056)) as "column7"
        ,cast(supplier_categories."column8" as varchar2(2056)) as "column8"
        ,cast(supplier_categories."column9" as varchar2(2056)) as "column9"
        ,cast(supplier_categories."column10" as varchar2(2056)) as "column10"
        ,cast(supplier_categories."column11" as varchar2(2056)) as "column11"
        ,cast(supplier_categories."column12" as varchar2(2056)) as "column12"
        ,null as "column13"
        ,null as "column14"
        ,null as "column15"
        ,null as "column16"
        ,null as "column17"
        ,null as "column18"
        ,null as "column19"
        ,null as "column20"
        ,null as "column21"
        ,null as "column22"
        ,null as "column23"
        ,null as "column24"
        ,null as "column25"
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"
        ,cast(to_char(supplier_categories."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(supplier_categories."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"    
    from supplier_categories
    --####
/*        
        union all
    select
        agreement_terms."ORDINAL_SORT"
        ,cast(agreement_terms."DATA_GROUP" as varchar2(256)) as "DATA_GROUP"
        ,cast(agreement_terms."DATA_SOURCE" as varchar2(512)) as "DATA_SOURCE"
        ,cast(agreement_terms."column1" as varchar2(2056)) as "column1"    
        ,cast(agreement_terms."column2" as varchar2(2056)) as "column2"
        ,cast(agreement_terms."column3" as varchar2(2056)) as "column3"
        ,cast(agreement_terms."column4" as varchar2(2056)) as "column4"
        ,cast(agreement_terms."column5" as varchar2(2056)) as "column5"
        ,cast(agreement_terms."column6" as varchar2(2056)) as "column6"
        ,cast(agreement_terms."column7" as varchar2(2056)) as "column7"
        ,cast(agreement_terms."column8" as varchar2(2056)) as "column8"
        ,cast(agreement_terms."column9" as varchar2(2056)) as "column9"
        ,cast(agreement_terms."column10" as varchar2(2056)) as "column10"
        ,cast(agreement_terms."column11" as varchar2(2056)) as "column11"
        ,cast(agreement_terms."column12" as varchar2(2056)) as "column12"
        ,agreement_terms."column13"
        ,null as "column14"
        ,null as "column15"
        ,null as "column16"
        ,null as "column17"
        ,null as "column18"
        ,null as "column19"
        ,null as "column20"
        ,null as "column21"
        ,null as "column22"
        ,null as "column23"
        ,null as "column24"
        ,null as "column25"
        ,null as "column26"
        ,null as "column27"
        ,null as "column28"
        ,null as "column29"
        ,null as "column30"
        ,null as "column31"
        ,null as "column32"
        ,null as "column33"
        ,null as "column34"
        ,null as "column35"
        ,null as "column36"
        ,null as "column37"
        ,null as "column38"
        ,null as "column39"
        ,null as "column40"
        ,null as "column41"
        ,null as "column42"
        ,null as "column43"
        ,null as "column44"
        ,null as "column45"
        ,null as "column46"
        ,null as "column47"
        ,null as "column48"        
        ,cast(to_char(agreement_terms."column49",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column49"
        ,cast(to_char(agreement_terms."column50",'MON DD YYYY HH12:MIAM') as varchar2(2056)) as "column50"        
    from agreement_terms
*/    
) results