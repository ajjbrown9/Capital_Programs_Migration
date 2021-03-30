/*####################################################
    Project Lineage Data Set
    Version:Project_Lineage_Query_Pkg2_11.13_v15

    ###############################################
    03/19/2021 - New in version 11.13_v15 (Round 4)
        Notes and Comments:
            - All extract queries include three header columns:
                - "ORDINAL_SORT"
                - "DATA_GROUP"
                - "DATA_SOURCE"
            These columns can assist with data management. If they are
            not needed, they are ok to delete or to not implement/ignore.

            - The AGREEMENT_BID_ITEMS data group CTE has been moved above
                the AUCTION_HEADER data group CTE and now directly interfaces
                with the PO_AGREEMENTS data group CTE. This provides a more precise
                AGREEMENT_BID_ITEMS data group to be returned. The
                AUCTION_HEADER data group CTE now interfaces with the
                AGREEMENT_BID_ITEMS data group CTE.

            - A new PROJECT_AWARDS data group column has been introduced:
                - "column16" as "ebs_awd_expended"
            This column provides expenditure/actuals of an award directly
            from the GMS Grant and Awards module to better balance award budgets.

            - All category code information and commodity code information has been
            introduced to data groups:
                - REQ_LINES
                - PO_LINES
                - AP_INV_LINES

            - Additional PO_HEADER data group columns have been introduced to better account
            for agreements and standard purchase orders with an RFQ#

            New join methods:
                PO_AGREEMENTS -> AGREEMENT_BID_ITEMS:
                    "ebs_agr_auc_header_id" = "ebs_auc_header_id"
                        and
                    "ebs_agr_bid_id" = "ebs_auc_bid_no_id"

        New Data Groups:
            SUPPLIER_CATEGORIES
        
        New Columns and Column Changes:
            PROJECT DATA GROUP
                - No Changes
            PROJECT_TASK
                - No Changes
            PROJECT_AWARDS
                - "column16" as "ebs_awd_expended"  --##NEW## 3/18/2021 -KKM
                - "column49" as "ebs_awd_create_dt" --##NEW## 3/18/2021 COLUMN NAME CHANGE FROM "agr_create_dt" -KKM
                - "column50" as "ebs_awd_update_dt" --##NEW## 3/18/2021 COLUMN NAME CHANGE FROM "agr_update_dt" -KKM
            REQ_DISTS
                - No Changes
            REQ_LINES
                - "column30" as "ebs_req_ln_cat_id"         --##NEW## 03/13/2021 -KKM
                - "column31" as "ebs_req_ln_cat_code"       --##NEW## 03/13/2021 -KKM
                - "column32" as "ebs_req_ln_cat_descr"      --##NEW## 03/13/2021 -KKM
                - "column33" as "ebs_req_ln_item_id"        --##NEW## 03/13/2021 -KKM
                - "column34" as "ebs_req_ln_item_class_1"   --##NEW## 03/13/2021 -KKM
                - "column35" as "ebs_req_ln_item_class_2"   --##NEW## 03/13/2021 -KKM
                - "column36" as "ebs_req_ln_item_class_3"   --##NEW## 03/13/2021 -KKM
                - "column37" as "ebs_req_ln_item_descr"     --##NEW## 03/13/2021 -KKM
            REQ_HEADERS
                - No Changes
            PO_DISTS
                - "column38" as "ebs_po_dist_expend_type"   --##NEW## 3/10/2021 -KKM
                - "column39" as "ebs_po_dist_expend_dt"     --##NEW## 3/10/2021 -KKM
            PO_LINES
                - "column18" as "ebs_po_ln_cat_id"          --##NEW## 03/10/2021 -KKM
                - "column19" as "ebs_po_ln_cat_code"        --##NEW## 03/10/2021 -KKM
                - "column20" as "ebs_po_ln_cat_descr"       --##NEW## 03/10/2021 -KKM
                - "column21" as "ebs_po_ln_item_id"         --##NEW## 03/10/2021 -KKM
                - "column22" as "ebs_po_ln_item_class_1"    --##NEW## 03/13/2021 -KKM
                - "column23" as "ebs_po_ln_item_class_2"    --##NEW## 03/13/2021 -KKM
                - "column24" as "ebs_po_ln_item_class_3"    --##NEW## 03/13/2021 -KKM
                - "column25" as "ebs_po_ln_item_descr"      --##NEW## 03/13/2021 -KKM
            PO_HEADERS
                - "column2" as "ebs_po_header_po_no"            --##NEW## 3/18/2021 COLUMN NAME CHANGE FROM "ebs_po_no" -KKM
                - "column14" as "ebs_po_header_doc_no"          --##NEW## 3/10/2021 -KKM
                - "column15" as "ebs_po_header_bid_src"         --##NEW## 3/10/2021 -KKM
                - "column16" as "ebs_po_header_bid_no"          --##NEW## 3/10/2021 -KKM
                - "column17" as "ebs_po_header_agent"           --##NEW## 3/10/2021 -KKM
                - "column18" as "ebs_po_header_renew_code"      --##NEW## 3/10/2021 -KKM
                - "column19" as "ebs_po_header_manager"         --##NEW## 3/10/2021 -KKM
                - "column20" as "ebs_po_header_managing_dept"   --##NEW## 3/10/2021 -KKM
                - "column21" as "ebs_po_header_type"            --##NEW## 3/10/2021 -KKM
                - "column22" as "ebs_po_header_auc_header_id"   --##NEW## 3/10/2021 -KKM
                - "column23" as "ebs_po_header_bid_id"          --##NEW## 3/10/2021 -KKM
                - "column24" as "ebs_po_header_from_header"     --##NEW## 3/19/2021 -KKM
                - "column25" as "ebs_po_header_doc_type"        --##NEW## 3/19/2021 -KKM                
                - "column49" as "ebs_po_header_create_dt"       --##NEW## 3/18/2021 COLUMN NAME CHANGE FROM "po_create_dt" -KKM
                - "column50" as "ebs_po_header_update_dt"       --##NEW## 3/18/2021 COLUMN NAME CHANGE FROM "po_update_dt" -KKM           
            PO_AGREEMENTS
                - "column30" as "ebs_agr_auc_header_id"     --##NEW## 3/10/2021 -KKM
                - "column31" as "ebs_agr_bid_id"            --##NEW## 3/10/2021 -KKM
                - "column32" as "ebs_agr_doc_type"          --##NEW## 3/19/2021 -KKM                
            AGREEMENT_BID_ITEMS
                - "ebs_auc_agr_id" --as "column21"          --##NEW## 3/10/2021 RESERVED -KKM
                - "column22" as "ebs_auc_itm_ln_no"         --##NEW## 3/10/2021 -KKM
                - "column23" as "ebs_auc_itm_doc_ln_no"     --##NEW## 3/10/2021 -KKM
                - "column24" as "ebs_auc_itm_req_no"        --##NEW## 3/10/2021 -KKM
                - "column25" as "ebs_auc_itm_cat_descr"     --##NEW## 3/10/2021 -KKM
            AUCTION_HEADER
                - "column20" as "ebs_auc_doc_type" --##NEW## 3/19/2021 -KKM
            AP_INV_DISTRIBUTIONS
                - No Changes
            AP_INV_LINES
                - "column11" as "ebs_ap_inv_ln_item_id" --##NEW## 03/13/2021
                - "column12" as "ebs_ap_inv_ln_item_class_1" --##NEW## 03/13/2021
                - "column13" as "ebs_ap_inv_ln_item_class_2" --##NEW## 03/13/2021
                - "column14" as "ebs_ap_inv_ln_item_class_3" --##NEW## 03/13/2021
                - "column15" as "ebs_ap_inv_ln_item_descr" --##NEW## 03/13/2021
                - "column16" as "ebs_ap_inv_ln_product_type" --##NEW## 03/13/2021
                - "column17" as "ebs_ap_inv_ln_line_code" --##NEW## 03/13/2021
                - "column18" as "ebs_ap_inv_ln_rtng_inv_id" --##NEW## 03/13/2021
                - "column19" as "ebs_ap_inv_ln_rtng_line_no" --##NEW## 03/13/2021
            AP_INV_HEADERS
                - No Changes
            AP_INV_PAYMENTS
                - No Changes
            SUPPLIERS
                - No Changes
            SUPPLIERS_CCNA
                - No Changes
            SUPPLIER_SITES
                - No Changes
            SUPPLIER_CONTACTS
                - No Changes
    ###############################################

    ###############################################
    Data Group Additional Information    
        PROJECT DATA GROUP:
            EBS TABLES:
                - PA_PROJECTS_ALL
                - PA_PROJECT_STATUSES
                - PA_PROJECT_CLASSES
            PRE-SORTED BY:
                - "ebs_prj_id" ASC
            PRIMARY KEY COLUMN:
                - "ebs_prj_id" (SURROGATE)
            FORIEGN KEY COLUMNS:
                - NONE
            RECOMMENDED DERIVED KEY COLUMNS:
                - NONE

        PROJECT_TASK DATA GROUP
            EBS TABLES:
                - PA_TASKS
            PRE-SORTED BY:
                - "ebs_pa_tsk_prj_id" ASC
                - "ebs_pa_tsk_tsk_id" ASC
            PRIMARY KEY COLUMN:
                - "ebs_pa_tsk_tsk_id" (SURROGATE)
            FORIEGN KEY COLUMNS:
                - "ebs_pa_tsk_prj_id"
            RECOMMENDED DERIVED KEY COLUMNS:
                - "ebs_pa_tsk_prj_id"||"ebs_pa_tsk_tsk_id"
        
        PROJECT_AWARDS DATA GROUP
            EBS TABLES:
                - GMS_BUDGET_VERSIONS
                - GMS_AWARDS_ALL
                - GMS_AWARD_DISTRIBUTIONS
            PRE-SORTED BY:
                - "ebs_awd_prj_id" ASC
                - "ebs_awd_awd_id" ASC
            PRIMARY KEY COLUMN:
                - "ebs_awd_prj_id"||"ebs_awd_awd_id" (COMPOSITE)(SURROGATE)
            FORIEGN KEY COLUMNS:
                - "ebs_awd_prj_id"
                - "ebs_awd_awd_id"
            RECOMMENDED DERIVED KEY COLUMNS:
                - NONE
        
        REQ_DISTS DATA GROUP
            EBS TABLES:
                - PO_REQ_DISTRIBUTIONS_ALL
                - HR_ALL_ORGANIZATION_UNITS
                - PO_REQUISITION_LINES_ALL
                - GL_CODE_COMBINATIONS
                - GMS_AWARDS_ALL
                - FND_FLEX_VALUES_VL
                - FND_FLEX_VALUE_SETS
            PRE-SORTED BY:
                - "ebs_req_dist_ln_id" ASC
                - "ebs_req_dist_id" ASC
            PRIMARY KEY COLUMN:
                - "ebs_req_dist_id" (SURROGATE)
            FORIEGN KEY COLUMNS:
                - "ebs_req_dist_ln_id"
                - "ebs_req_dist_code_id"
                - "ebs_req_dist_prj_id"
                - "ebs_req_dist_tsk_id"
                - "ebs_req_dist_award_id"
                - "ebs_req_dist_expend_org_id"
                - "ebs_req_ln_agr_id"
                - "ebs_req_ln_agr_ln_no"
                - "ebs_req_ln_header_id"
            RECOMMENDED DERIVED KEY COLUMNS:
                - "ebs_req_dist_prj_id"||"ebs_req_dist_tsk_id"
                - "ebs_req_dist_prj_id"||"ebs_req_dist_award_id"
                - "ebs_req_ln_header_id"||"ebs_req_dist_ln_id"
        
        REQ_LINES DATA GROUP
            EBS TABLES:
                - PO_REQUISITION_LINES_ALL
                - MTL_CATEGORIES_VL
                - MTL_SYSTEM_ITEMS_B
            PRE-SORTED BY:
                - "ebs_req_ln_header_id" ASC
                - "ebs_req_ln_id" ASC
            PRIMARY KEY COLUMN:
                - "ebs_req_ln_id" (SURROGATE)
            FORIEGN KEY COLUMNS:
                - "ebs_req_ln_header_id"
                - "ebs_req_ln_agr_id"
                - "ebs_req_ln_agr_ln_no"
                - "ebs_req_ln_vendor_id"
                - "ebs_req_ln_vendor_site_id"
                - "ebs_req_ln_vendor_contact_id"
                - "ebs_req_ln_cat_id"
                - "ebs_req_ln_item_id"
            RECOMMENDED DERIVED KEY COLUMNS:
                - "ebs_req_ln_header_id"||"ebs_req_ln_id"

        REQ_HEADERS DATA GROUP
            EBS TABLES:
                - PO_REQUISITION_HEADERS_ALL
            PRE-SORTED BY:
                - "ebs_req_header_id" ASC
            PRIMARY KEY COLUMN:
                - "ebs_req_header_id" (SURROGATE)
            FORIEGN KEY COLUMNS:
                - NONE
            RECOMMENDED DERIVED KEY COLUMNS:
                - NONE
            
        PO_DISTS DATA GROUP
            EBS TABLES:
                - PO_DISTRIBUTIONS_ALL
                - PO_LINES_ALL
                - GL_CODE_COMBINATIONS
                - GMS_AWARD_DISTRIBUTIONS
                - GMS_AWARDS_ALL
                - HR_ALL_ORGANIZATION_UNITS
            PRE-SORTED BY:
                - "ebs_po_dist_po_header_id" ASC
                - "ebs_po_dist_po_line_id" ASC
                - "ebs_po_dist_id" ASC
            PRIMARY KEY COLUMN:
                - "ebs_po_dist_id" (SURROGATE)
            FORIEGN KEY COLUMNS:
                - "ebs_po_dist_po_header_id"
                - "ebs_po_dist_po_line_id"
                - "ebs_po_dist_code_combo"
                - "ebs_po_dist_award_id"
                - "ebs_po_dist_prj_id"
                - "ebs_po_dist_tsk_id"
                - "ebs_po_dist_req_dist_id"
                - "ebs_po_dist_org_expend_id"
                - "ebs_po_ln_agr_id"
            RECOMMENDED DERIVED KEY COLUMNS:
                - "ebs_po_dist_po_header_id"||"ebs_po_dist_po_line_id"
                - "ebs_po_dist_prj_id"||"ebs_po_dist_tsk_id"
                - "ebs_po_dist_prj_id"||"ebs_po_dist_award_id"
                - "ebs_po_dist_id"||"ebs_po_dist_req_dist_id"
                
            PO_LINES DATA GROUP
                EBS TABLES:
                    - PO_LINES_ALL
                    - MTL_CATEGORIES_VL
                    - MTL_SYSTEM_ITEMS_B
                PRE-SORTED BY:
                    - "ebs_po_ln_header_id" ASC
                    - "ebs_po_ln_ln_id" ASC
                PRIMARY KEY COLUMN:
                    - "ebs_po_ln_ln_id" (SURROGATE)
                FORIEGN KEY COLUMNS:
                    - "ebs_po_ln_header_id"
                    - "ebs_po_ln_agr_id"
                    - "ebs_po_ln_cat_id"
                    - "ebs_po_ln_item_id"
                RECOMMENDED DERIVED KEY COLUMNS:
                    - "ebs_po_ln_header_id"||"ebs_po_ln_ln_id"
                
            PO_HEADERS DATA GROUP
                EBS TABLES:
                    - PO_HEADERS_ALL
                    - PON_AUCTION_HEADERS_ALL
                    - PON_BID_HEADERS
                    - PER_ALL_PEOPLE_F
                    - PER_ALL_ASSIGNMENTS_F
                    - HR_ALL_POSITIONS_F
                    - HR_ALL_ORGANIZATION_UNITS
                PRE-SORTED BY:
                    - "ebs_po_header_auc_header_id" ASC
                    - "ebs_po_header_bid_id" ASC
                    - "ebs_po_header_id" ASC
                    - "ebs_po_header_vendor_id"
                    - "ebs_po_header_vendor_site_id"
                PRIMARY KEY COLUMN:
                    - "ebs_po_header_id"
                FORIEGN KEY COLUMNS:
                    - "ebs_po_header_vendor_id"
                    - "ebs_po_header_vendor_site_id"
                    - "ebs_po_header_vendor_contact_id"
                    - "ebs_po_header_auc_header_id"
                    - "ebs_po_header_bid_id"
                RECOMMENDED DERIVED KEY COLUMNS:
                    - "ebs_po_header_auc_header_id"||"ebs_po_header_bid_id"
                
            PO_AGREEMENTS DATA GROUP
                EBS TABLES:
                    - PO_HEADERS_ALL
                    - PON_AUCTION_HEADERS_ALL
                    - PON_BID_HEADERS
                    - PER_ALL_PEOPLE_F
                    - PER_ALL_ASSIGNMENTS_F
                    - HR_ALL_POSITIONS_F
                    - HR_ALL_ORGANIZATION_UNITS
                PRE-SORTED BY:
                    - "ebs_agr_auc_header_id" ASC
                    - "ebs_agr_bid_id" ASC
                    - "ebs_agr_id" ASC
                    - "ebs_agr_vendor_id" ASC
                    - "ebs_agr_vendor_site_id" ASC
                PRIMARY KEY COLUMN:
                    - "ebs_agr_id" (SURROGATE)
                FORIEGN KEY COLUMNS:
                    - "ebs_agr_vendor_id"
                    - "ebs_agr_vendor_site_id"
                    - "ebs_agr_vendor_contact_id"
                    - "ebs_agr_from_header_id"
                    - "ebs_agr_auc_header_id"
                    - "ebs_agr_bid_id"
                RECOMMENDED DERIVED KEY COLUMNS:
                    - "ebs_agr_auc_header_id"||"ebs_agr_bid_id"

            AGREEMENT_BID_ITEMS DATA GROUP
                EBS TABLES:
                    - PON_AUCTION_HEADERS_ALL
                    - PON_BID_ITEM_PRICES
                    - PON_BID_HEADERS
                    - PON_AUCTION_ITEM_PRICES_ALL
                    - AP_SUPPLIERS
                    - MTL_CATEGORIES_VL
                PRE-SORTED BY:
                    - "ebs_auc_header_id" ASC
                    - "ebs_auc_bid_no_id" ASC
                    - "ebs_auc_itm_ln_no" ASC"
                    - "ebs_auc_itm_line_no" ASC
                    - "ebs_bid_vendor_id" ASC
                PRIMARY KEY COLUMN:
                    - "ebs_auc_bid_no_id"||"ebs_auc_itm_ln_no"||"ebs_auc_itm_doc_ln_no" (COMPOSITE)(SURROGATE)
                FORIEGN KEY COLUMNS:
                    - "ebs_auc_header_id"
                    - "ebs_auc_bid_no_id"
                    - "ebs_bid_vendor_id"
                    - "ebs_bid_vendor_site_id"
                    - "ebs_bid_po_header_id"
                    - "ebs_auc_itm_cat_id"
                    - "ebs_auc_bid_no"
                    - "ebs_auc_itm_req_no"
                RECOMMENDED DERIVED KEY COLUMNS:
                    - "ebs_auc_header_id"||"ebs_auc_bid_no_id"

            AUCTION_HEADER DATA GROUP
                EBS TABLES:
                    - PON_AUCTION_HEADERS_ALL
                    - PON_FORMS_INSTANCES
                    - PON_FORM_SECTION_COMPILED
                    - PON_FORM_FIELD_VALUES
                PRE-SORTED BY:
                    - "ebs_auc_header_id" ASC
                PRIMARY KEY COLUMN:
                    - "ebs_auc_header_id"
                FORIEGN KEY COLUMNS:
                    - "ebs_auc_bid_no"
                    - "ebs_auc_req_no"
                    - "ebs_auc_partner_id"
                RECOMMENDED DERIVED KEY COLUMNS:
                    - NONE

            AP_INV_DISTRIBUTIONS DATA GROUP
                EBS TABLES:
                    - AP_INVOICE_DISTRIBUTIONS_ALL
                    - GL_CODE_COMBINATIONS
                    - GMS_AWARD_DISTRIBUTIONS
                    - GMS_AWARDS_ALL
                    - HR_ALL_ORGANIZATION_UNITS
                PRE-SORTED BY:
                    - "ebs_ap_inv_dist_po_dist_id" ASC
                    - "ebs_ap_inv_dist_inv_id" ASC
                    - "ebs_ap_inv_dist_inv_ln_no" ASC
                    - "ebs_ap_inv_dist_id" ASC
                    - "ebs_ap_inv_dist_ln_no" ASC
                PRIMARY KEY COLUMN:
                    - "ebs_ap_inv_dist_id" (SURROGATE)
                FORIEGN KEY COLUMNS:
                    - "ebs_ap_inv_dist_inv_id"
                    - "ebs_ap_inv_dist_inv_ln_no"
                    - "ebs_ap_inv_dist_po_dist_id"
                    - "ebs_ap_inv_dist_code_combo_id"
                    - "ebs_ap_inv_dist_prj_id"
                    - "ebs_ap_inv_dist_tsk_id"
                    - "ebs_ap_inv_dist_awd_id"
                    - "ebs_ap_inv_dist_expend_org_id"
                RECOMMENDED DERIVED KEY COLUMNS:
                    - "ebs_ap_inv_dist_prj_id"||"ebs_ap_inv_dist_tsk_id"
                    - "ebs_ap_inv_dist_prj_id"||"ebs_ap_inv_dist_awd_id"
                    - "ebs_ap_inv_dist_inv_id"||"ebs_ap_inv_dist_inv_ln_no"

            AP_INV_LINES DATA GROUP
                EBS TABLES:
                    - AP_INVOICE_LINES_ALL
                    - MTL_SYSTEM_ITEMS_B
                PRE-SORTED BY:
                    - "ebs_ap_inv_ln_inv_id" ASC
                    - "ebs_ap_inv_ln_no" ASC
                PRIMARY KEY COLUMN:
                    - "ebs_ap_inv_ln_inv_id"||'.'||"ebs_ap_inv_ln_no" (COMPOSITE) (SURROGATE)
                FORIEGN KEY COLUMNS:
                    - "ebs_ap_inv_ln_inv_id"
                    - "ebs_ap_inv_ln_item_id"
                RECOMMENDED DERIVED KEY COLUMNS:
                    - NONE

            AP_INV_HEADERS DATA GROUP
                EBS TABLES:
                    - AP_INVOICES_ALL
                    - AP_SUPPLIERS
                PRE-SORTED BY:
                    - "ebs_ap_inv_id" ASC
                PRIMARY KEY COLUMN:
                    - "ebs_ap_inv_id"
                FORIEGN KEY COLUMNS:
                    - "ebs_ap_inv_vendor_id"
                    - "ap_inv_header_vendor_site_id"
                    - "ap_inv_header_vendor_contact_id"
                    - "ap_inv_header_party_id"
                    - "ap_inv_header_party_site_id"
                RECOMMENDED DERIVED KEY COLUMNS:
                    - "ebs_ap_inv_vendor_id"||"ap_inv_header_vendor_site_id"
                    - "ap_inv_header_party_id"||"ap_inv_header_party_site_id"

            AP_INV_PAYMENTS DATA GROUP
                EBS TABLES:
                    - AP_INVOICE_PAYMENTS_ALL
                    - AP_CHECKS_ALL
                PRE-SORTED BY:
                    - "ebs_ap_inv_check_id" ASC
                    - "ebs_ap_inv_invoice_id" ASC
                    - "ebs_ap_inv_payment_id" ASC
                    - "ebs_ap_inv_vendor_id" ASC
                    - "ebs_ap_inv_acct_event_id" ASC
                PRIMARY KEY COLUMN:
                    - "ebs_ap_inv_acct_event_id"||"ebs_ap_inv_invoice_id" (COMPOSITE) (SURROGATE)
                FORIEGN KEY COLUMNS:
                    - "ebs_ap_inv_invoice_id"
                    - "ebs_ap_inv_check_run_id"
                    - "ebs_ap_inv_payment_id"
                    - "ebs_ap_inv_check_id"
                    - "ebs_ap_inv_vendor_id"
                    - "ebs_ap_inv_vendor_site_id"
                RECOMMENDED DERIVED KEY COLUMNS:
                    - "ebs_ap_inv_vendor_id"||"ebs_ap_inv_vendor_site_id"
            
            SUPPLIERS DATA GROUP
                EBS TABLES:
                    - AP_SUPPLIERS
                PRE-SORTED BY:
                    - "ebs_supplier_vendor_id" ASC
                PRIMARY KEY COLUMN:
                    - "ebs_supplier_vendor_id"
                FORIEGN KEY COLUMNS:
                    - NONE
                RECOMMENDED DERIVED KEY COLUMNS:
                    -NONE

            SUPPLIERS_CCNA DATA GROUP
                EBS TABLES:
                    - AP_SUPPLIERS
                    - POS_BUS_CLASS_ATTR
                PRE_SORTED BY:
                    - "ebs_supplier_vendor_id" ASC
                PRIMARY KEY COLUMN:
                    - "ebs_supplier_vendor_id"||"ebs_supplier_classification" (COMPOSITE) (SURROGATE)
                FORIEGN KEY COLUMNS:
                    - "ebs_supplier_vendor_id"
                RECOMMENDED DERIVED KEY COLUMNS:
                    - NONE
            
            SUPPLIER_SITES DATA GROUP
                EBS TABLES:
                    - AP_SUPPLIER_SITES_ALL
                PRE-SORTED BY:
                    - "ebs_supp_site_vendor_id" ASC
                    - "ebs_supp_site_site_id" ASC
                PRIMARY KEY COLUMN:
                    - "ebs_supp_site_site_id"
                FORIEGN KEY COLUMNS:
                    - "ebs_supp_site_vendor_id"
                RECOMMENDED DERIVED KEY COLUMNS:
                    - "ebs_supp_site_vendor_id"||"ebs_supp_site_site_id"
            
            SUPPLIER_CONTACTS DATA GROUP
                EBS TABLES:
                    - AP_SUPPLIER_CONTACTS
                PRE-SORTED BY:
                    - "ebs_supp_con_site_id" ASC
                    - "ebs_supp_con_vendor_id" ASC
                PRIMARY KEY COLUMN:
                    - "ebs_supp_con_vendor_id" (SURROGATE)
                FORIEGN KEY COLUMNS:
                    - "ebs_supp_con_site_id"
                RECOMMENDED DERIVED KEY COLUMNS:
                    - "ebs_supp_con_site_id"||"ebs_supp_con_vendor_id"
            
            SUPPLIER_CATEGORIES DATA GROUP
                EBS TABLES:
                    - POS_SUP_PRODUCTS_SERVICES
                    - MTL_CATEGORIES_VL
                PRE-SORTED BY:
                    - "ebs_supplier_cat_vendor_id" ASC
                    - "ebs_supplier_cat_id" ASC
                    - "ebs_supplier_cat_class_id" ASC
                PRIMARY KEY COLUMN:
                    - "ebs_supplier_cat_class_id"
                FORIEGN KEY COLUMNS:
                    - "ebs_supplier_cat_vendor_id"
                    - "ebs_supplier_cat_id"
                    - "ebs_supplier_cat_structure_id"
                RECOMMENDED DERIVED KEY COLUMNS:
                    - "ebs_supplier_cat_vendor_id"||"ebs_supplier_cat_id"
    ###############################################

#######################################################*/

/*####START PROJECT DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_prj_id"          
    ,your_stage_table."column2" as "ebs_prj_long_name"
    ,your_stage_table."column3" as "ebs_prj_no"
    ,your_stage_table."column4" as "ebs_prj_type"
    ,your_stage_table."column5" as "ebs_prj_descr"
    ,your_stage_table."column6" as "ebs_prj_star_dt"
    ,your_stage_table."column7" as "ebs_prj_completion_dt"
    ,your_stage_table."column8" as "ebs_prj_status"
    ,your_stage_table."column9" as "ebs_prj_neighborhood_code"
    ,your_stage_table."column10" as "ebs_prj_program_code"
    ,your_stage_table."column11" as "ebs_prj_sub_program_code"
    ,your_stage_table."column12" as "ebs_prj_step_process"
    ,your_stage_table."column13" as "ebs_prj_fund_class"
    ,your_stage_table."column14" as "ebs_prj_master_project"            
    ,your_stage_table."column15" as "ebs_prj_program_type"
    ,your_stage_table."column16" as "ebs_prj_service_impact"
    ,your_stage_table."column17" as "ebs_prj_impact_fee_zone"
    ,your_stage_table."column18" as "ebs_prj_commissioner_district"
    ,your_stage_table."column49" as "ebs_prj_create_dt"
    ,your_stage_table."column50" as "ebs_prj_update_dt"         
from your_stage_table
where your_stage_table."DATA_GROUP" = 'PROJECT'
/*####END PROJECT DATA GROUP EXTRACTION QUERY####*/

/*####START PROJECT_TASK DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_pa_tsk_prj_id"
    ,your_stage_table."column2" as "ebs_pa_tsk_tsk_id"
    ,your_stage_table."column3" as "ebs_pa_tsk_top_tsk_no"
    ,your_stage_table."column4" as "ebs_pa_tsk_tsk_no"
    ,your_stage_table."column5" as "ebs_pa_tsk_name"
    ,your_stage_table."column6" as "ebs_pa_tsk_tsk_descr"
    ,your_stage_table."column7" as "ebs_pa_tsk_tsk_start_dt"
    ,your_stage_table."column8" as "ebs_pa_tsk_end_dt"
    ,your_stage_table."column9" as "ebs_pa_tsk_center"
    ,your_stage_table."column10" as "ebs_pa_tsk_tsk_activity"
    ,your_stage_table."column11"  as "ebs_pa_tsk_tsk_sub_acct"
    ,your_stage_table."column12" as "ebs_pa_tsk_status"
    ,your_stage_table."column13" as "ebs_pa_tsk_pde_phase"
    ,your_stage_table."column49" as "ebs_prj_tsk_create_dt"
    ,your_stage_table."column50" as "ebs_prj_tsk_update_dt"
from your_stage_table
where your_stage_table."DATA_GROUP" = 'PROJECT_TASK'
/*####END PROJECT_TASK DATA GROUP EXTRACTION QUERY####*/

/*####START PROJECT_AWARDS DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_awd_prj_id"
    ,your_stage_table."column2" as "ebs_awd_awd_id"
    ,your_stage_table."column3" as "ebs_awd_allocation"            
    ,your_stage_table."column4" as "ebs_awd_awd_no"            
    ,your_stage_table."column5" as "ebs_awd_short_name"
    ,your_stage_table."column6" as "ebs_awd_long_name"
    ,your_stage_table."column7" as "ebs_awd_src_no"
    ,your_stage_table."column8" as "ebs_awd_purpose_code"
    ,your_stage_table."column9" as "ebs_awd_status"
    ,your_stage_table."column10" as "ebs_awd_start_dt"
    ,your_stage_table."column11" as "ebs_awd_end_dt"
    ,your_stage_table."column12" as "ebs_awd_close_dt"
    ,your_stage_table."column13" as "ebs_awd_fund_no"
    ,your_stage_table."column14" as "ebs_awd_activity"
    ,your_stage_table."column15" as "ebs_awd_type"
    ,your_stage_table."column16" as "ebs_awd_expended"  --##NEW## 03/18/2021 -KKM
    ,your_stage_table."column49" as "ebs_awd_create_dt" --##NEW## 3/18/2021 COLUMN NAME CHANGE FROM "agr_create_dt" -KKM
    ,your_stage_table."column50" as "ebs_awd_update_dt" --##NEW## 3/18/2021 COLUMN NAME CHANGE FROM "agr_update_dt" -KKM
from your_stage_table                         
where your_stage_table."DATA_GROUP" = 'PROJECT_AWARDS'
/*####END PROJECT_AWARDS DATA GROUP EXTRACTION QUERY####*/

/*####START REQ_DISTS DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_req_dist_ln_id"
    ,your_stage_table."column2" as "ebs_req_dist_id"
    ,your_stage_table."column3" as "ebs_req_dist_code_id"
    ,your_stage_table."column4" as "ebs_req_dist_prj_id"
    ,your_stage_table."column5" as "ebs_req_dist_tsk_id"
    ,your_stage_table."column6" as "ebs_req_dist_fund"
    ,your_stage_table."column7" as "ebs_req_dist_fund_name"
    ,your_stage_table."column8" as "ebs_req_dist_center"
    ,your_stage_table."column9" as "ebs_req_dist_center_name"
    ,your_stage_table."column10" as "ebs_req_dist_account"
    ,your_stage_table."column11" as "ebs_req_dist_account_name"
    ,your_stage_table."column12" as "ebs_req_dist_sub_account"
    ,your_stage_table."column13" as "ebs_req_dist_activity"                        
    ,your_stage_table."column14" as "ebs_req_dist_exp_type"
    ,your_stage_table."column15" as "ebs_req_dist_ln_qty"
    ,your_stage_table."column16" as "ebs_req_dist_ln_amt"
    ,your_stage_table."column17" as "ebs_req_dist_award_id"            
    ,your_stage_table."column18" as "ebs_req_dist_award_no"
    ,your_stage_table."column19" as "ebs_req_dist_expend_org_id"
    ,your_stage_table."column20" as "ebs_req_dist_expend_org"
    ,your_stage_table."column21" as "ebs_req_dist_expend_admin"
    ,your_stage_table."column22" as "ebs_req_dist_enc_dt"
    ,your_stage_table."column23" as "ebs_req_dist_canceled_dt"
    ,your_stage_table."column24" as "ebs_req_dist_expend_itm_dt"
    ,your_stage_table."column25" as "ebs_req_dist_enc_amt"
    ,your_stage_table."column26" as "ebs_req_ln_agr_id"           
    ,your_stage_table."column27" as "ebs_req_ln_agr_ln_no"
    ,your_stage_table."column28" as "ebs_req_ln_header_id"                       
    ,your_stage_table."column49" as "ebs_req_dist_create_dt"
    ,your_stage_table."column50" as "ebs_req_dist_update_dt" 
from your_stage_table
where your_stage_table."DATA_GROUP" = 'REQ_DISTS'
/*####END REQ_DISTS DATA GROUP EXTRACTION QUERY####*/

/*####START REQ_LINES DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_req_ln_header_id"
    ,your_stage_table."column2" as "ebs_req_ln_id"
    ,your_stage_table."column3" as "ebs_req_ln_no"
    ,your_stage_table."column4" as "ebs_req_ln_itm_descr"
    ,your_stage_table."column5" as "ebs_req_ln_uom"
    ,your_stage_table."column6" as "ebs_req_ln_up"
    ,your_stage_table."column7" as "ebs_req_ln_qty"            
    ,your_stage_table."column8" as "ebs_req_ln_qty_delivered"
    ,your_stage_table."column9" as "ebs_req_ln_need_by_dt"         
    ,your_stage_table."column10" as "ebs_req_ln_agent_note"
    ,your_stage_table."column11" as "ebs_req_ln_receiver_note"
    ,your_stage_table."column12" as "ebs_req_ln_doc_type"           
    ,your_stage_table."column13" as "ebs_req_ln_agr_id"           
    ,your_stage_table."column14" as "ebs_req_ln_agr_ln_no"
    ,your_stage_table."column15" as "ebs_req_ln_cncl_flg"            
    ,your_stage_table."column16" as "ebs_req_ln_cncl_qty"
    ,your_stage_table."column17" as "ebs_req_ln_cncl_dt"
    ,your_stage_table."column18" as "ebs_req_ln_cncl_note"            
    ,your_stage_table."column19" as "ebs_req_ln_vendor_id"
    ,your_stage_table."column20" as "ebs_req_ln_vendor_site_id"
    ,your_stage_table."column21" as "ebs_req_ln_vendor_contact_id"
    ,your_stage_table."column22" as "ebs_req_ln_dept"
    ,your_stage_table."column23" as "ebs_req_ln_pcard_flg"
    ,your_stage_table."column24" as "ebs_req_ln_vendor_note"  
    ,your_stage_table."column25" as "ebs_req_ln_order_type"
    ,your_stage_table."column26" as "ebs_req_ln_purch_basis" 
    ,your_stage_table."column27" as "ebs_req_ln_base_up"
    ,your_stage_table."column28" as "ebs_req_ln_wo_no"
    ,your_stage_table."column29" as "ebs_req_ln_amt"
    ,your_stage_table."column30" as "ebs_req_ln_cat_id"         --##NEW## 03/13/2021 -KKM
    ,your_stage_table."column31" as "ebs_req_ln_cat_code"       --##NEW## 03/13/2021 -KKM
    ,your_stage_table."column32" as "ebs_req_ln_cat_descr"      --##NEW## 03/13/2021 -KKM
    ,your_stage_table."column33" as "ebs_req_ln_item_id"        --##NEW## 03/13/2021 -KKM
    ,your_stage_table."column34" as "ebs_req_ln_item_class_1"   --##NEW## 03/13/2021 -KKM
    ,your_stage_table."column35" as "ebs_req_ln_item_class_2"   --##NEW## 03/13/2021 -KKM
    ,your_stage_table."column36" as "ebs_req_ln_item_class_3"   --##NEW## 03/13/2021 -KKM
    ,your_stage_table."column37" as "ebs_req_ln_item_descr"     --##NEW## 03/13/2021 -KKM
    ,your_stage_table."column49" as "ebs_req_ln_create_dt"
    ,your_stage_table."column50" as "ebs_req_ln_update_dt"
from your_stage_table
where your_stage_table."DATA_GROUP" = 'REQ_LINES'
/*####END REQ_LINES DATA GROUP EXTRACTION QUERY####*/

/*####START REQ_HEADERS DATA EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_req_header_id"
    ,your_stage_table."column2" as "ebs_req_header_no"
    ,your_stage_table."column3" as "ebs_req_auth_status"
    ,your_stage_table."column4" as "ebs_req_header_descr"
    ,your_stage_table."column5" as "ebs_req_header_auth_note"
    ,your_stage_table."column6" as "ebs_req_header_cncl_flg"
    ,your_stage_table."column7" as "ebs_req_header_clsd_code"
    ,your_stage_table."column8" as "ebs_req_header_appr_dt"
    ,your_stage_table."column49" as "ebs_req_header_create_dt"
    ,your_stage_table."column50" as "ebs_req_header_update_dt"
from your_stage_table
where your_stage_table."DATA_GROUP" = 'REQ_HEADERS'
/*####END REQ_HEADERS DATA EXTRACTION QUERY####*/

/*####START PO_DISTS DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_po_dist_po_header_id"
    ,your_stage_table."column2" as "ebs_po_dist_po_line_id"
    ,your_stage_table."column3" as "ebs_po_dist_id"
    ,your_stage_table."column4" as "ebs_po_dist_code_combo"
    ,your_stage_table."column5" as "ebs_po_dist_type"
    ,your_stage_table."column6" as "ebs_po_dist_fund"
    ,your_stage_table."column7" as "ebs_po_dist_fund_name"
    ,your_stage_table."column8" as "ebs_po_dist_center"
    ,your_stage_table."column9" as "ebs_po_dist_center_name"
    ,your_stage_table."column10" as "ebs_po_dist_account"
    ,your_stage_table."column11" as "ebs_po_dist_account_name"
    ,your_stage_table."column12" as "ebs_po_dist_sub_account"
    ,your_stage_table."column13" as "ebs_po_dist_activity"
    ,your_stage_table."column14" as "ebs_po_dist_award_id"
    ,your_stage_table."column15" as "ebs_po_dist_enc_amt"
    ,your_stage_table."column16" as "ebs_po_dist_unenc_amt"
    ,your_stage_table."column17" as "ebs_po_dist_to_enc_amt"
    ,your_stage_table."column18" as "ebs_po_dist_ordered_amt"
    ,your_stage_table."column19" as "ebs_po_dist_delivered_amt"
    ,your_stage_table."column20" as "ebs_po_dist_amt_cncl"
    ,your_stage_table."column21" as "ebs_po_dist_amt_reversed"
    ,your_stage_table."column22" as "ebs_po_dist_rtng_released"
    ,your_stage_table."column23" as "ebs_po_dist_rtng_withheld"
    ,your_stage_table."column24" as "ebs_po_dist_amt_billed"
    ,your_stage_table."column25" as "ebs_po_dist_qty_ordered"
    ,your_stage_table."column26" as "ebs_po_dist_qty_unenc"
    ,your_stage_table."column27" as "ebs_po_dist_qty_delivered"
    ,your_stage_table."column28" as "ebs_po_dist_qty_billed"
    ,your_stage_table."column29" as "ebs_po_dist_qty_canceled"
    ,your_stage_table."column30" as "ebs_po_dist_prj_id"
    ,your_stage_table."column31" as "ebs_po_dist_tsk_id"
    ,your_stage_table."column32" as "ebs_po_dist_req_dist_id"
    ,your_stage_table."column33" as "ebs_po_dist_org_expend_id"
    ,your_stage_table."column34" as "ebs_po_dist_expend_org"
    ,your_stage_table."column35" as "ebs_po_dist_expend_admin"
    ,your_stage_table."column36" as "ebs_po_ln_agr_id"
    ,your_stage_table."column37" as "ebs_po_dist_award_no"
    ,your_stage_table."column38" as "ebs_po_dist_expend_type"   --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column39" as "ebs_po_dist_expend_dt"     --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column49" as "po_dist_create_dt"
    ,your_stage_table."column50" as "po_dist_update_dt"
from your_stage_table                         
where your_stage_table."DATA_GROUP" = 'PO_DISTS'
/*####END PO_DISTS DATA GROUP EXTRACTION QUERY####*/

/*####START PO_LINES DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_po_ln_header_id"
    ,your_stage_table."column2" as "ebs_po_ln_ln_id"
    ,your_stage_table."column3" as "ebs_po_ln__no"
    ,your_stage_table."column4" as "ebs_po_ln_agr_id"                       
    ,your_stage_table."column5" as "ebs_po_ln_close" 
    ,your_stage_table."column6" as "ebs_po_ln_cncl_flg"
    ,your_stage_table."column7" as "ebs_po_ln_descr"
    ,your_stage_table."column8" as 'ebs_po_ln_rtng_rt'              
    ,your_stage_table."column9" as "ebs_po_ln_unit_lookup"                  
    ,your_stage_table."column10" as "ebs_po_ln_unit_price"
    ,your_stage_table."column11" as "ebs_po_ln_qty"
    ,your_stage_table."column12" as "ebs_po_ln_matching_basis"
    ,your_stage_table."column13" as "ebs_po_ln_cancel_dt"
    ,your_stage_table."column14" as "ebs_po_ln_cancel_descr"               
    ,your_stage_table."column15" as "ebs_po_ln_close_dt"
    ,your_stage_table."column16" as "ebs_po_ln_close_descr"
    ,your_stage_table."column17" as "ebs_po_ln_amt"
    ,your_stage_table."column18" as "ebs_po_ln_cat_id"          --##NEW## 03/10/2021 -KKM
    ,your_stage_table."column19" as "ebs_po_ln_cat_code"        --##NEW## 03/10/2021 -KKM
    ,your_stage_table."column20" as "ebs_po_ln_cat_descr"       --##NEW## 03/10/2021 -KKM
    ,your_stage_table."column21" as "ebs_po_ln_item_id"         --##NEW## 03/10/2021 -KKM
    ,your_stage_table."column22" as "ebs_po_ln_item_class_1"    --##NEW## 03/13/2021 -KKM
    ,your_stage_table."column23" as "ebs_po_ln_item_class_2"    --##NEW## 03/13/2021 -KKM
    ,your_stage_table."column24" as "ebs_po_ln_item_class_3"    --##NEW## 03/13/2021 -KKM
    ,your_stage_table."column25" as "ebs_po_ln_item_descr"      --##NEW## 03/13/2021 -KKM
    ,your_stage_table."column49" as "po_ln_create_dt"
    ,your_stage_table."column50" as "po_ln_update_dt"
from your_stage_table                         
where your_stage_table."DATA_GROUP" = 'PO_LINES'
/*####END PO_LINES DATA GROUP EXTRACTION QUERY####*/

/*####START PO_HEADERS DATA_GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_po_header_id"
    ,your_stage_table."column2" as "ebs_po_header_po_no"                --##NEW## 3/18/2021 COLUMN NAME CHANGE FROM "ebs_po_no" -KKM
    ,your_stage_table."column3" as "ebs_po_header_cncl_flg"
    ,your_stage_table."column4" as "ebs_po_header_auth_status"
    ,your_stage_table."column5" as "ebs_po_header_approved_dt"
    ,your_stage_table."column6" as "ebs_po_header_closed_code"
    ,your_stage_table."column7" as "ebs_po_header_closed_dt"
    ,your_stage_table."column8" as "ebs_po_header_title"
    ,your_stage_table."column9" as "ebs_po_header_rev_no"
    ,your_stage_table."column10" as "ebs_po_header_rev_dt"
    ,your_stage_table."column11" as "ebs_po_header_vendor_id"            
    ,your_stage_table."column12" as "ebs_po_header_vendor_site_id"    
    ,your_stage_table."column13" as "ebs_po_header_vendor_contact_id"
    ,your_stage_table."column14" as "ebs_po_header_doc_no"              --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column15" as "ebs_po_header_bid_src"             --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column16" as "ebs_po_header_bid_no"              --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column17" as "ebs_po_header_agent"               --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column18" as "ebs_po_header_renew_code"          --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column19" as "ebs_po_header_manager"             --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column20" as "ebs_po_header_managing_dept"       --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column21" as "ebs_po_header_type"                --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column22" as "ebs_po_header_auc_header_id"       --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column23" as "ebs_po_header_bid_id"              --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column24" as "ebs_po_header_from_header"         --##NEW## 3/19/2021 -KKM
    ,your_stage_table."column25" as "ebs_po_header_doc_type"            --##NEW## 3/19/2021 -KKM
    ,your_stage_table."column49" as "ebs_po_header_create_dt"           --##NEW## 3/18/2021 COLUMN NAME CHANGE FROM "po_create_dt" -KKM
    ,your_stage_table."column50" as "ebs_po_header_update_dt"           --##NEW## 3/18/2021 COLUMN NAME CHANGE FROM "po_update_dt" -KKM
from your_stage_table                         
where your_stage_table."DATA_GROUP" = 'PO_HEADERS'
/*####END PO_HEADERS DATA_GROUP EXTRACTION QUERY####*/

/*####START PO_AGREEMENTS DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_agr_id"
    ,your_stage_table."column2" as "ebs_agr_no"
    ,your_stage_table."column3" as "ebs_agr_manager"
    ,your_stage_table."column4" as "ebs_managing_dept"
    ,your_stage_table."column5" as "ebs_agr_agent"
    ,your_stage_table."column6" as "ebs_agr_bid_no"
    ,your_stage_table."column7" as "ebs_agr_term_start_dt"
    ,your_stage_table."column8" as "ebs_agr_term_end_dt"
    ,your_stage_table."column9" as "ebs_agr_doc_no"
    ,your_stage_table."column10" as "ebs_agr_type"
    ,your_stage_table."column11" as "ebs_agr_src_type"
    ,your_stage_table."column12" as "ebs_agr_src_descr"                       
    ,your_stage_table."column13" as "ebs_agr_renew_code"     
    ,your_stage_table."column14" as "ebs_agr_auth_status"
    ,your_stage_table."column15" as "ebs_agr_auth_dt"
    ,your_stage_table."column16" as "ebs_agr_cncl"
    ,your_stage_table."column17" as "ebs_agr_terms"
    ,your_stage_table."column18" as "ebs_agr_rev_no"      
    ,your_stage_table."column19" as "ebs_agr_rev_dt"
    ,your_stage_table."column20" as "ebs_agr_vendor_note"
    ,your_stage_table."column21" as "ebs_agr_receive_note"
    ,your_stage_table."column22" as "ebs_agr_authorizer_note"
    ,your_stage_table."column23" as "ebs_agr_title"
    ,your_stage_table."column24" as "ebs_agr_amt"
    ,your_stage_table."column25" as "ebs_agr_vendor_id"
    ,your_stage_table."column26" as "ebs_agr_vendor_site_id"
    ,your_stage_table."column27" as "ebs_agr_vendor_contact_id"
    ,your_stage_table."column28" as "ebs_agr_from_header_id"
    ,your_stage_table."column29" as "ebs_agr_active_status"
    ,your_stage_table."column30" as "ebs_agr_auc_header_id"     --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column31" as "ebs_agr_bid_id"            --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column32" as "ebs_agr_doc_type"          --##NEW## 3/19/2021 -KKM    
    ,your_stage_table."column49" as "ebs_agr_create_dt"
    ,your_stage_table."column50" as "ebs_agr_update_dt"
from your_stage_table                         
where your_stage_table."DATA_GROUP" = 'PO_AGREEMENTS'
/*####END PO_AGREEMENTS DATA GROUP EXTRACTION QUERY####*/

/*####START AGREEMENT_BID_ITEMS DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_auc_header_id"
    ,your_stage_table."column2" as "ebs_auc_bid_no_id"
    ,your_stage_table."column3" as "ebs_bid_vendor_id"
    ,your_stage_table."column4" as "ebs_bid_vendor_name"
    ,your_stage_table."column5" as "ebs_bid_vendor_site_id"
    ,your_stage_table."column6" as "ebs_bid_po_header_id"
    ,your_stage_table."column7" as "ebs_bid_award_status"
    ,your_stage_table."column8" as "ebs_bid_contract_type"
    ,your_stage_table."column9" as "ebs_auc_itm_cat_id"
    ,your_stage_table."column10" as "ebs_auc_itm_cat_name"
    ,your_stage_table."column11" as "ebs_auc_itm_order_type"
    ,your_stage_table."column12" as "ebs_auc_itm_purch_basis"
    ,your_stage_table."column13" as "ebs_auc_itm_line_no"
    ,your_stage_table."column14" as "ebs_auc_itm_disp_line_no"
    ,your_stage_table."column15" as "ebs_auc_itm_descr"
    ,your_stage_table."column16" as "ebs_auc_itm_qty"
    ,your_stage_table."column17" as "ebs_auc_itm_uom_code"
    ,your_stage_table."column18" as "ebs_auc_itm_uom_descr"
    ,your_stage_table."column19" as "ebs_auc_itm_awd_price"
    ,your_stage_table."column20" as "ebs_auc_bid_no"
    ,null as "ebs_auc_agr_id" --as "column21"                   --##NEW## 3/10/2021 RESERVED -KKM
    ,your_stage_table."column22" as "ebs_auc_itm_ln_no"         --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column23" as "ebs_auc_itm_doc_ln_no"     --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column24" as "ebs_auc_itm_req_no"        --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column25" as "ebs_auc_itm_cat_descr"     --##NEW## 3/10/2021 -KKM
    ,your_stage_table."column49" as "ebs_auc_itm_create_dt"
    ,your_stage_table."column50" as "ebs_auc_itm_update_dt"
from your_stage_table
where your_stage_table."DATA_GROUP" = 'AGREEMENT_BID_ITEMS'
/*####END AGREEMENT_BID_ITEMS DATA GROUP EXTRACTION QUERY####*/

/*####START AUCTION_HEADER DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_auc_header_id"
    ,your_stage_table."column2" as "ebs_auc_bid_no"
    ,your_stage_table."column3" as "ebs_auc_title"
    ,your_stage_table."column4" as "ebs_auc_event_title"
    ,your_stage_table."column5" as "ebs_auc_status"
    ,your_stage_table."column6" as "ebs_auc_award_status"
    ,your_stage_table."column7" as "ebs_auc_type"
    ,your_stage_table."column8" as "ebs_auc_contract_type"
    ,your_stage_table."column9" as "ebs_auc_partner_id"
    ,your_stage_table."column10" as "ebs_auc_open_bid_dt"
    ,your_stage_table."column11" as "ebs_auc_close_bid_dt"
    ,your_stage_table."column12" as "ebs_auc_outcome"
    ,your_stage_table."column13" as "ebs_auc_complete_dt"
    ,your_stage_table."column14" as "ebs_auc_award_dt"
    ,your_stage_table."column15" as "ebs_auc_appr_stat"
    ,your_stage_table."column16" as "ebs_auc_award_appr_stat"
    ,your_stage_table."column17" as "ebs_auc_amend_no"
    ,your_stage_table."column18" as "ebs_auc_amend_desc"
    ,your_stage_table."column19" as "ebs_auc_req_no"
    ,your_stage_table."column20" as "ebs_auc_doc_type" --##NEW## 3/19/2021 -KKM                
    ,your_stage_table."column49" as "ebs_auc_create_dt"
    ,your_stage_table."column50" as "ebs_auc_update_dt"
from your_stage_table
where your_stage_table."DATA_GROUP" = 'AUCTION_HEADER'
/*####END AUCTION_HEADER DATA GROUP EXTRACTION QUERY####*/

/*####START AP_INV_DISTRIBUTIONS DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_ap_inv_dist_inv_id"
    ,your_stage_table."column2" as "ebs_ap_inv_dist_inv_ln_no"
    ,your_stage_table."column3" as "ebs_ap_inv_dist_ln_no"
    ,your_stage_table."column4" as "ebs_ap_inv_dist_id"
    ,your_stage_table."column5" as "ebs_ap_inv_dist_po_dist_id"
    ,your_stage_table."column6" as "ebs_ap_inv_dist_code_combo_id"
    ,your_stage_table."column7" as "ebs_ap_inv_dist_prj_id"
    ,your_stage_table."column8" as "ebs_ap_inv_dist_tsk_id"
    ,your_stage_table."column9" as "ebs_ap_inv_dist_awd_id"
    ,your_stage_table."column10" as "ebs_ap_inv_dist_acct_dt"
    ,your_stage_table."column11" as "ebs_ap_inv_dist_exp_dt"
    ,your_stage_table."column12" as "ebs_ap_inv_dist_exp_type"
    ,your_stage_table."column13" as "ebs_ap_inv_dist_match_type"
    ,your_stage_table."column14" as "ebs_ap_inv_dist_match_uom"
    ,your_stage_table."column15" as "ebs_ap_inv_dist_rvrs_flg"
    ,your_stage_table."column16" as "ebs_ap_inv_dist_cncl_flg"
    ,your_stage_table."column17" as "ebs_ap_inv_dist_qty"
    ,your_stage_table."column18" as "ebs_ap_inv_dist_up"                        
    ,your_stage_table."column19" as "ebs_ap_inv_dist_base_amt"
    ,your_stage_table."column20" as "ebs_ap_inv_dist_amt"
    ,your_stage_table."column21" as "ebs_ap_inv_dist_rtng_remaining"
    ,your_stage_table."column22" as "ebs_ap_inv_dist_fund_no"
    ,your_stage_table."column23" as "ebs_ap_inv_dist_fund_name"
    ,your_stage_table."column24" as "ebs_ap_inv_dist_center"
    ,your_stage_table."column25" as "ebs_ap_inv_dist_center_name"           
    ,your_stage_table."column26" as "ebs_ap_inv_dist_acct"
    ,your_stage_table."column27" as "ebs_ap_inv_dist_acct_name"                             
    ,your_stage_table."column28" as "ebs_ap_inv_dist_sub_acct"
    ,your_stage_table."column29" as "ebs_ap_inv_dist_activity"
    ,your_stage_table."column30" as "ebs_ap_inv_dist_awd_no"
    ,your_stage_table."column31" as "ebs_ap_inv_dist_expend_org_id"
    ,your_stage_table."column32" as "ebs_ap_inv_dist_expend_org"
    ,your_stage_table."column33" as "ebs_ap_inv_dist_expend_admin"
    ,your_stage_table."column49" as "ebs_ap_inv_dist_create_dt"
    ,your_stage_table."column50" as "ebs_ap_inv_dist_update_dt"
from your_stage_table                         
where your_stage_table."DATA_GROUP" = 'AP_INV_DISTRIBUTIONS'
/*####END AP_INV_DISTRIBUTIONS DATA GROUP EXTRACTION QUERY####*/

/*####START AP_INV_LINES DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_ap_inv_ln_inv_id"
    ,your_stage_table."column2" as "ebs_ap_inv_ln_no"
    ,your_stage_table."column3" as "ebs_ap_inv_ln_descr"
    ,your_stage_table."column4" as "ebs_ap_inv_ln_itm_descr"
    ,your_stage_table."column5" as "ebs_ap_inv_ln_discard_flg"
    ,your_stage_table."column6" as "ebs_ap_inv_ln_cancel_flg"
    ,your_stage_table."column7" as "ebs_ap_inv_ln_src"
    ,your_stage_table."column8" as "ebs_ap_inv_ln_qty"
    ,your_stage_table."column9" as "ebs_ap_inv_ln_uom"
    ,your_stage_table."column10" as "ebs_ap_inv_ln_up"
    ,your_stage_table."column11" as "ebs_ap_inv_ln_item_id" --##NEW## 03/13/2021
    ,your_stage_table."column12" as "ebs_ap_inv_ln_item_class_1" --##NEW## 03/13/2021
    ,your_stage_table."column13" as "ebs_ap_inv_ln_item_class_2" --##NEW## 03/13/2021
    ,your_stage_table."column14" as "ebs_ap_inv_ln_item_class_3" --##NEW## 03/13/2021
    ,your_stage_table."column15" as "ebs_ap_inv_ln_item_descr" --##NEW## 03/13/2021
    ,your_stage_table."column16" as "ebs_ap_inv_ln_product_type" --##NEW## 03/13/2021
    ,your_stage_table."column17" as "ebs_ap_inv_ln_line_code" --##NEW## 03/13/2021
    ,your_stage_table."column18" as "ebs_ap_inv_ln_rtng_inv_id" --##NEW## 03/13/2021
    ,your_stage_table."column19" as "ebs_ap_inv_ln_rtng_line_no" --##NEW## 03/13/2021    
    ,your_stage_table."column49" as "ebs_ap_inv_ln_create_dt"
    ,your_stage_table."column50" as "ebs_ap_inv_ln_update_dt"  
from your_stage_table                         
where your_stage_table."DATA_GROUP" = 'AP_INV_LINES'
/*####END AP_INV_LINES DATA GROUP EXTRACTION QUERY####*/

/*####START AP_INV_HEADERS DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_ap_inv_id"
    ,your_stage_table."column2" as "ebs_ap_inv_no"
    ,your_stage_table."column3" as "ebs_ap_inv_descr"
    ,your_stage_table."column4" as "ebs_ap_inv_gl_dt"
    ,your_stage_table."column5" as "ebs_ap_inv_dt"
    ,your_stage_table."column6" as "ebs_ap_inv_received_dt"
    ,your_stage_table."column7" as "ebs_ap_inv_cncl_dt"
    ,your_stage_table."column8" as "ebs_ap_inv_amt"
    ,your_stage_table."column9" as "ebs_ap_inv_appr_amt"
    ,your_stage_table."column10" as "ebs_ap_inv_src"
    ,your_stage_table."column11" as "ebs_ap_inv_vendor_id"
    ,your_stage_table."column12" as "ap_inv_header_vendor_site_id"    
    ,your_stage_table."column13" as "ap_inv_header_vendor_contact_id"
    ,your_stage_table."column14" as "ap_inv_header_party_id"
    ,your_stage_table."column15" as "ap_inv_header_party_site_id"  
    ,your_stage_table."column16" as "ap_inv_header_vendor_name"
    ,your_stage_table."column17" as "ap_inv_header_discount_amt"
    ,your_stage_table."column18" as "ap_inv_header_canceled_amt"
    ,your_stage_table."column19" as "ap_inv_header_pay_group_code"
    ,your_stage_table."column20" as "ap_inv_header_type_lookup_code"
    ,your_stage_table."column49" as "ebs_ap_inv_created_dt"
    ,your_stage_table."column50" as "ebs_ap_inv_update_dt"
from your_stage_table                         
where your_stage_table."DATA_GROUP" = 'AP_INV_HEADERS'
/*####END AP_INV_HEADERS DATA GROUP EXTRACTION QUERY####*/

/*####START AP_INV_PAYMENTS DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_ap_inv_invoice_id"
    ,your_stage_table."column2" as "ebs_ap_inv_check_run_id"
    ,your_stage_table."column3" as "ebs_ap_inv_payment_id"
    ,your_stage_table."column4" as "ebs_ap_inv_paym_method"
    ,your_stage_table."column5" as "ebs_ap_inv_checkrun_name"
    ,your_stage_table."column6" as "ebs_ap_inv_check_id"
    ,your_stage_table."column7" as "ebs_ap_inv_check_no"
    ,your_stage_table."column8" as "ebs_ap_inv_check_dt"
    ,your_stage_table."column9" as "ebs_ap_inv_check_clear_dt"
    ,your_stage_table."column10" as "ebs_ap_inv_payment_amt"
    ,your_stage_table."column11" as "ebs_ap_inv_acct_event_id"
    ,your_stage_table."column12" as "ebs_ap_inv_acct_dt"
    ,your_stage_table."column13" as "ebs_ap_inv_payment_reversed"
    ,your_stage_table."column14" as "ebs_ap_inv_vendor_id"
    ,your_stage_table."column15" as "ebs_ap_inv_vendor_site_id"
    ,your_stage_table."column16" as "ebs_ap_inv_payment_num"
    ,your_stage_table."column49" as "ebs_ap_inv_create_dt"
    ,your_stage_table."column50" as "ebs_ap_inv_update_dt"  
from your_stage_table                         
where your_stage_table."DATA_GROUP" = 'AP_INV_PAYMENTS'
/*####END AP_INV_PAYMENTS DATA GROUP EXTRACTION QUERY####*/

/*####START SUPPLIERS DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_supplier_vendor_id"
    ,your_stage_table."column2" as "ebs_supplier_vendor_name"
    ,your_stage_table."column3" as "ebs_supplier_start_dt"
    ,your_stage_table."column4" as "ebs_supplier_end_dt"
    ,your_stage_table."column5" as "ebs_supplier_party_id"
    ,your_stage_table."column6" as "ebs_supplier_party_parent_id"
    ,your_stage_table."column7" as "ebs_supplier_enabled_flg"
    ,your_stage_table."column8" as "ebs_supplier_type"
    ,your_stage_table."column9" as "ebs_supplier_woman_owned"
    ,your_stage_table."column10" as "ebs_supplier_small_biz"
    ,your_stage_table."column11" as "ebs_supplier_minority"
    ,your_stage_table."column49" as "ebs_supplier_created_dt"
    ,your_stage_table."column50" as "ebs_supplier_updated_dt"
from your_stage_table                         
where your_stage_table."DATA_GROUP" = 'SUPPLIERS'
/*####END SUPPLIERS DATA GROUP EXTRACTION QUERY####*/

/*####START SUPPLIERS_CCNA DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_supplier_vendor_id"
    ,your_stage_table."column2" as "ebs_supplier_vendor_name"
    ,your_stage_table."column3" as "ebs_supplier_classification"
    ,your_stage_table."column4" as "ebs_supplier_exp_dt"
from your_stage_table                         
where your_stage_table."DATA_GROUP" = 'SUPPLIERS_CCNA'
/*####END SUPPLIERS_CCNA DATA GROUP EXTRACTION QUERY####*/

/*####START SUPPLIER_SITES DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_supp_site_vendor_id"
    ,your_stage_table."column2" as "ebs_supp_site_site_id"
    ,your_stage_table."column3" as "ebs_supp_site_code"
    ,your_stage_table."column4" as "ebs_supp_site_purch_flg"
    ,your_stage_table."column5" as "ebs_supp_site_addr_1"
    ,your_stage_table."column6" as "ebs_supp_site_addr_2"
    ,your_stage_table."column7" as "ebs_supp_site_city"
    ,your_stage_table."column8" as "ebs_supp_site_state"
    ,your_stage_table."column9" as "ebs_supp_site_zip"
    ,your_stage_table."column10" as "ebs_supp_site_prov"
    ,your_stage_table."column11" as "ebs_supp_site_cntry"
    ,your_stage_table."column12" as "ebs_supp_site_area_code"
    ,your_stage_table."column13" as "ebs_supp_site_phone"
    ,your_stage_table."column14" as "ebs_supp_site_inactive_dt"
    ,your_stage_table."column15" as "ebs_supp_site_fax"
    ,your_stage_table."column16" as "ebs_supp_site_fax_area_code"
    ,your_stage_table."column17" as "ebs_supp_site_notif_meth"
    ,your_stage_table."column18" as "ebs_supp_site_email"
    ,your_stage_table."column19" as "ebs_supp_site_party_site_id"
    ,your_stage_table."column49" as "ebs_supp_site_creation_dt"
    ,your_stage_table."column50" as "ebs_supp_site_update_dt"
from your_stage_table                         
where your_stage_table."DATA_GROUP" = 'SUPPLIER_SITES'
/*####END SUPPLIER_SITES DATA GROUP EXTRACTION QUERY####*/

/*####START SUPPLIER_CONTACTS DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_supp_con_vendor_id"
    ,your_stage_table."column2" as "ebs_supp_con_site_id"
    ,your_stage_table."column3" as "ebs_supp_con_inactive_dt"
    ,your_stage_table."column4" as "ebs_supp_con_first_name"
    ,your_stage_table."column5" as "ebs_supp_con_middle_name"
    ,your_stage_table."column6" as "ebs_supp_con_last_name"
    ,your_stage_table."column7" as "ebs_supp_con_title"
    ,your_stage_table."column8" as "ebs_supp_con_area_code"
    ,your_stage_table."column9" as "ebs_supp_con_phone"
    ,your_stage_table."column10" as "ebs_supp_con_email"
    ,your_stage_table."column11" as "ebs_supp_con_fname_alt"
    ,your_stage_table."column12" as "ebs_supp_con_lname_alt"
    ,your_stage_table."column13" as "ebs_supp_con_area_code_alt"
    ,your_stage_table."column14" as "ebs_supp_con_phone_alt"
    ,your_stage_table."column15" as "ebs_supp_con_fax"
    ,your_stage_table."column16" as "ebs_supp_con_fax_area_code"
    ,your_stage_table."column17" as "ebs_supp_con_url"
    ,your_stage_table."column18" as "ebs_supp_con_per_party_id"
    ,your_stage_table."column19" as "ebs_supp_con_relation_id"
    ,your_stage_table."column20" as "ebs_supp_con_rel_party_id"
    ,your_stage_table."column21" as "ebs_supp_con_party_site_id"
    ,your_stage_table."column22" as "ebs_supp_con_org_contact_id"
    ,your_stage_table."column23" as "ebs_supp_con_org_party_site_id"
    ,your_stage_table."column49" as "ebs_supp_con_create_dt"
    ,your_stage_table."column50" as "ebs_supp_con_update_dt"
from your_stage_table                         
where your_stage_table."DATA_GROUP" = 'SUPPLIER_CONTACTS'
/*####END SUPPLIER_CONTACTS DATA GROUP EXTRACTION QUERY####*/

/*####START SUPPLIER_CATEGORIES DATA GROUP EXTRACTION QUERY####*/
select
    your_stage_table."ORDINAL_SORT" as "ORDINAL_SORT"
    ,your_stage_table."DATA_GROUP" as "DATA_GROUP"
    ,your_stage_table."DATA_SOURCE" as "DATA_SOURCE"
    ,your_stage_table."column1" as "ebs_supplier_cat_class_id" --##NEW## 03/10/2021
    ,your_stage_table."column2" as "ebs_supplier_cat_vendor_id" --##NEW## 03/10/2021
    ,your_stage_table."column3" as "ebs_supplier_cat_category" --##NEW## 03/10/2021
    ,your_stage_table."column4" as "ebs_supplier_cat_sub_category" --##NEW## 03/10/2021
    ,your_stage_table."column5" as "ebs_supplier_cat_category_code" --##NEW## 03/10/2021
    ,your_stage_table."column6" as "ebs_supplier_cat_status" --##NEW## 03/10/2021
    ,your_stage_table."column7" as "ebs_supplier_cat_segment_definition" --##NEW## 03/10/2021
    ,your_stage_table."column8" as "ebs_supplier_cat_id" --##NEW## 03/10/2021
    ,your_stage_table."column9" as "ebs_supplier_cat_structure_id" --##NEW## 03/10/2021
    ,your_stage_table."column10" as "ebs_supplier_cat_summary_flg" --##NEW## 03/10/2021
    ,your_stage_table."column11" as "ebs_supplier_cat_enabled_flg" --##NEW## 03/10/2021
    ,your_stage_table."column12" as "ebs_supplier_cat_description" --##NEW## 03/10/2021
    ,your_stage_table."column49" as "ebs_supplier_cat_services_create_dt" --##NEW## 03/10/2021
    ,your_stage_table."column50" as "ebs_supplier_cat_services_update_dt" --##NEW## 03/10/2021
from your_stage_table                         
where your_stage_table."DATA_GROUP" = 'SUPPLIER_CATEGORIES'
/*####END SUPPLIER_CATEGORIES DATA GROUP EXTRACTION QUERY####*/