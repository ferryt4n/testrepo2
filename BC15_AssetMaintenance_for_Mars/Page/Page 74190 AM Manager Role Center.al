page 74190 "MCH AM Manager Role Center"
{
    Caption = 'Asset Maintenance Manager';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            part(Control1904652008;"MCH AM Manager RC Activities")
            {
                ApplicationArea = Basic,Suite;
            }
            part(Control1101214006;"My Vendors")
            {
                AccessByPermission = TableData "Vendor Ledger Entry"=R;
                ApplicationArea = Basic,Suite;
            }
            part(Control1101214009;"My Items")
            {
                ApplicationArea = Basic,Suite;
            }
            part(Control1101214000;"Report Inbox Part")
            {
                AccessByPermission = TableData "Report Inbox"=IMD;
                ApplicationArea = Basic,Suite;
            }
            part(Control21;"My Job Queue")
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1901377608;MyNotes)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(sections)
        {
            group(Asset)
            {
                action(Assets)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Assets';
                    Image = ServiceItem;
                    RunObject = Page "MCH Maintenance Asset List";
                }
                action("Asset Maint. Tasks")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Asset Maint. Tasks';
                    Image = ServiceTasks;
                    RunObject = Page "MCH Asset Maint. Task List";
                }
                action("Asset Usage Monitors")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Asset Usage Monitors';
                    Image = Capacity;
                    RunObject = Page "MCH Asset Usage Monitors";
                }
                action("Asset Structure List")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Asset Structure List';
                    Image = Hierarchy;
                    RunObject = Page "MCH Maint. Asset Struct. List";
                }
            }
            group("Work Orders")
            {
                Caption = 'Work Orders';
                action("Work Order Requests")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Work Order Requests';
                    Image = OrderList;
                    RunObject = Page "MCH Work Order Requests";
                }
                action("Planned Work Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Planned Work Orders';
                    Image = OrderList;
                    RunObject = Page "MCH Planned Work Orders";
                }
                action("Released Work Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Released Work Orders';
                    Image = OrderList;
                    RunObject = Page "MCH Released Work Orders";
                }
                action("Ongoing Work Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Ongoing Work Orders';
                    Image = OrderList;
                    RunObject = Page "MCH Ongoing Work Orders";
                }
                action("Ongoing Work Order Lines")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Ongoing Work Order Lines';
                    Image = List;
                    RunObject = Page "MCH Ongoing WO Lines";
                }
            }
            group(Purchasing)
            {
                Caption = 'Purchasing';
                action(Vendors)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Vendors';
                    RunObject = Page "Vendor List";
                    ToolTip = 'View or edit detailed information for the vendors that you trade with. From each vendor card, you can open related information, such as purchase statistics and ongoing orders, and you can define special prices and line discounts that the vendor grants you if certain conditions are met.';
                }
                action("Purchase Quotes")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Quotes';
                    RunObject = Page "Purchase Quotes";
                    ToolTip = 'Create purchase quotes to represent your request for quotes from vendors. Quotes can be converted to purchase orders.';
                    Visible = false;
                }
                action("<Page Purchase Orders>")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Orders';
                    RunObject = Page "Purchase Order List";
                    ToolTip = 'Create purchase orders to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase orders dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase orders allow partial receipts, unlike with purchase invoices, and enable drop shipment directly from your vendor to your customer. Purchase orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.';
                }
                action("<Page Purchase Invoices>")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Invoices';
                    RunObject = Page "Purchase Invoices";
                    ToolTip = 'Create purchase invoices to mirror sales documents that vendors send to you. This enables you to record the cost of purchases and to track accounts payable. Posting purchase invoices dynamically updates inventory levels so that you can minimize inventory costs and provide better customer service. Purchase invoices can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature.';
                }
                action("Purchase Return Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Return Orders';
                    RunObject = Page "Purchase Return Order List";
                    ToolTip = 'Create purchase return orders to mirror sales return documents that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. Purchase return orders enable you to ship back items from multiple purchase documents with one purchase return and support warehouse documents for the item handling. Purchase return orders can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.';
                }
                action("<Page Purchase Credit Memos>")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Credit Memos';
                    RunObject = Page "Purchase Credit Memos";
                    ToolTip = 'Create purchase credit memos to mirror sales credit memos that vendors send to you for incorrect or damaged items that you have paid for and then returned to the vendor. If you need more control of the purchase return process, such as warehouse documents for the physical handling, use purchase return orders, in which purchase credit memos are integrated. Purchase credit memos can be created automatically from PDF or image files from your vendors by using the Incoming Documents feature. Note: If you have not yet paid for an erroneous purchase, you can simply cancel the posted purchase invoice to automatically revert the financial transaction.';
                }
            }
        }
        area(embedding)
        {
            action(Action57)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Assets';
                Image = ServiceItem;
                RunObject = Page "MCH Maintenance Asset List";
            }
            action(Action46)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Asset Maint. Tasks';
                Image = ServiceTasks;
                RunObject = Page "MCH Asset Maint. Task List";
            }
            action(Action1101214053)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Asset Usage Monitors';
                Image = Capacity;
                RunObject = Page "MCH Asset Usage Monitors";
            }
        }
        area(creation)
        {
            action("Work Order Request")
            {
                AccessByPermission = TableData "MCH Work Order Header"=IMD;
                ApplicationArea = Basic,Suite;
                Caption = 'Work Order Request';
                Image = NewOrder;
                RunObject = Page "MCH Work Order Request";
                RunPageMode = Create;
            }
            action("Planned Work Order")
            {
                AccessByPermission = TableData "MCH Work Order Header"=IMD;
                ApplicationArea = Basic,Suite;
                Caption = 'Planned Work Order';
                Image = NewOrder;
                RunObject = Page "MCH Planned Work Order";
                RunPageMode = Create;
            }
            action("Released Work Order")
            {
                AccessByPermission = TableData "MCH Work Order Header"=IMD;
                ApplicationArea = Basic,Suite;
                Caption = 'Released Work Order';
                Image = NewOrder;
                RunObject = Page "MCH Released Work Order";
                RunPageMode = Create;
            }
            action("<Page Purchase Order>")
            {
                AccessByPermission = TableData "Purchase Header"=IMD;
                ApplicationArea = Basic,Suite;
                Caption = 'Purchase Order';
                Image = NewOrder;
                RunObject = Page "Purchase Order";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            action("Maint. Inventory Journal")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Maint. Inventory Journal';
                Image = Journal;
                RunObject = Page "MCH Maint. Inventory Journal";
            }
            action("Maint. Timesheet Journal")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Maint. Timesheet Journal';
                Image = Journal;
                RunObject = Page "MCH Maint. Timesheet Jnl.";
            }
            action("Usage Journal")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Usage Journal';
                Image = Journal;
                RunObject = Page "MCH Usage Journal";
            }
            action("Maint. Planning Worksheet")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Maint. Planning Worksheet';
                Image = Worksheet;
                RunObject = Page "MCH AM Planning Worksheet";
            }
            group(Inventory)
            {
                Caption = 'Inventory';
                Image = Journals;
                action(Items)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Items';
                    Image = List;
                    RunObject = Page "Item List";
                }
                action("Requisition Worksheet")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Requisition Worksheet';
                    Image = Worksheet;
                    RunObject = Page "Req. Worksheet";
                    ToolTip = 'Calculate a supply plan to fulfill item demand with purchases or transfers.';
                }
                action("Item Journal")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Item Journal';
                    Image = Journals;
                    RunObject = Page "Item Journal";
                    ToolTip = 'Adjust the physical quantity of items on inventory.';
                }
            }
            group("Maintenance Forecast")
            {
                Caption = 'Maintenance Forecast';
                action("Forecast Overview")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Forecast Overview';
                    Image = SuggestLines;
                    RunObject = Page "MCH Maint. FCast Overview";
                }
            }
            group(History)
            {
                Caption = 'History';
                action("Asset Cost Overview")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Asset Cost Overview';
                    Image = EntriesList;
                    RunObject = Page "MCH MA Cost Overview";
                    RunPageMode = Edit;
                }
                action("Asset Structure Cost Overview")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Asset Structure Cost Overview';
                    Image = EntriesList;
                    RunObject = Page "MCH MA Struct.Cost Overview";
                    RunPageMode = Edit;
                }
                action("Finished Work Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Finished Work Orders';
                    Image = PostedServiceOrder;
                    RunObject = Page "MCH Finished Work Orders";
                    ToolTip = 'Open the list of finished work orders.';
                }
                action("AM Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Ledger Entries';
                    Image = ServiceLedger;
                    RunObject = Page "MCH AM Ledger Entries";
                    ToolTip = 'Open the list of asset maintenance ledger entries.';
                }
                action("Usage Monitor Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Usage Monitor Entries';
                    Image = CapacityLedger;
                    RunObject = Page "MCH Usage Monitor Entries";
                    ToolTip = 'Open the list of registered usage monitor entries.';
                }
                action("Resource Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Resource Ledger Entries';
                    Image = ResourceLedger;
                    RunObject = Page "Resource Ledger Entries";
                    RunPageView = SORTING("MCH Work Order No.","MCH WO Budget Line No.","MCH Work Order Line No.")
                                  WHERE("MCH Work Order No."=FILTER(<>''));
                    ToolTip = 'Open the list of resource ledger entries related to work orders.';
                }
                action("Item Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Item Ledger Entries';
                    Image = ItemLedger;
                    RunObject = Page "Item Ledger Entries";
                    RunPageView = SORTING("MCH Work Order No.","MCH WO Budget Line No.","MCH Work Order Line No.")
                                  WHERE("MCH Work Order No."=FILTER(<>''));
                    ToolTip = 'Open the list of item ledger entries related to work orders.';
                }
                group("Posted Purchase Lines")
                {
                    Caption = 'Posted Purchase Lines';
                    action("Posted Purch. Receipt Lines")
                    {
                        AccessByPermission = TableData "Purch. Rcpt. Line"=R;
                        ApplicationArea = Basic,Suite;
                        Caption = 'Posted Purch. Receipt Lines';
                        Image = PostedReceipts;
                        RunObject = Page "Posted Purchase Receipt Lines";
                        RunPageView = SORTING("MCH Work Order No.","MCH WO Budget Line No.","MCH Work Order Line No.")
                                      WHERE("MCH Work Order No."=FILTER(<>''));
                        ToolTip = 'Open the list of posted purchase receipt lines related to work orders.';
                    }
                    action("Posted Purch. Invoice Lines")
                    {
                        AccessByPermission = TableData "Purch. Inv. Line"=R;
                        ApplicationArea = Basic,Suite;
                        Caption = 'Posted Purch. Invoice Lines';
                        Image = PostedTaxInvoice;
                        RunObject = Page "Posted Purchase Invoice Lines";
                        RunPageView = SORTING("MCH Work Order No.","MCH WO Budget Line No.","MCH Work Order Line No.")
                                      WHERE("MCH Work Order No."=FILTER(<>''));
                        ToolTip = 'Open the list of posted purchase invoice lines related to work orders.';
                    }
                    action("Posted Return Shipment Lines")
                    {
                        AccessByPermission = TableData "Return Shipment Line"=R;
                        ApplicationArea = Basic,Suite;
                        Caption = 'Posted Return Shipment Lines';
                        Image = PostedReturnReceipt;
                        RunObject = Page "Posted Return Shipment Lines";
                        RunPageView = SORTING("MCH Work Order No.","MCH WO Budget Line No.","MCH Work Order Line No.")
                                      WHERE("MCH Work Order No."=FILTER(<>''));
                        ToolTip = 'Open the list of posted return shipment lines related to work orders.';
                    }
                    action("Posted Purch. CR/Adj Note Lines")
                    {
                        AccessByPermission = TableData "Purch. Cr. Memo Line"=R;
                        ApplicationArea = Basic,Suite;
                        Caption = 'Posted Purch. CR/Adj Note Lines';
                        Image = PostedCreditMemo;
                        RunObject = Page "Posted Purchase Cr. Memo Lines";
                        RunPageView = SORTING("MCH Work Order No.","MCH WO Budget Line No.","MCH Work Order Line No.")
                                      WHERE("MCH Work Order No."=FILTER(<>''));
                        ToolTip = 'Open the list of posted purchase CR/Adj Note lines related to work orders.';
                    }
                }
                action("AM Posting Registers")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Posting Registers';
                    Image = Register;
                    RunObject = Page "MCH AM Posting Registers";
                }
                action(Navigate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Navigate';
                    Image = Navigate;
                    RunObject = Page Navigate;
                }
            }
            group("Periodic Activities")
            {
                Caption = 'Periodic Activities';
                group(PeriodicActMaintenance)
                {
                    Caption = 'Maintenance Schedule';
                    Image = ResourcePlanning;
                    action("Calculate Scheduled Maintenance")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Calculate Scheduled Maintenance';
                        Image = MachineCenterCalendar;
                        RunObject = Report "MCH Calc Scheduled Maint.";
                    }
                }
                group(PeriodicActPurchasing)
                {
                    Caption = 'Purchasing';
                    Image = Purchasing;
                    action("Suggest Maintenance Purchase")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Suggest Maintenance Purchase';
                        Ellipsis = true;
                        Image = CreateDocument;
                        RunObject = Page "MCH AM Purchase Wizard";
                        ToolTip = 'Open a wizard that will assist creating purchase order(s) based on released work order budget lines.';
                    }
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                Image = Setup;
                action("Asset Maintenance Setup")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Asset Maintenance Setup';
                    Image = ServiceSetup;
                    RunObject = Page "MCH Asset Maintenance Setup";
                    RunPageMode = View;
                }
                action("Maintenance User Setup")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Maintenance User Setup';
                    Image = UserSetup;
                    RunObject = Page "MCH Asset Maint. User List";
                    RunPageMode = View;
                }
                action("Maintenance Locations")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Maintenance Locations';
                    Image = MachineCenter;
                    RunObject = Page "MCH Maintenance Location List";
                }
                action("Asset Responsibilty Groups")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Asset Responsibilty Groups';
                    Image = ServiceItemGroup;
                    RunObject = Page "MCH Asset Resp. Group List";
                }
                group(General)
                {
                    Caption = 'General';
                    Image = Setup;
                    action("Work Order Types")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Work Order Types';
                        RunObject = Page "MCH Work Order Type List";
                    }
                    action("WO Progress Status")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'WO Progress Status';
                        RunObject = Page "MCH WO Progress Status List";
                    }
                    action("Work Instructions")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Work Instructions';
                        RunObject = Page "MCH Work Instruction List";
                    }
                    action("Work Instr. Categories")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Work Instr. Categories';
                        RunObject = Page "MCH Work Instr. Categories";
                    }
                    action("Asset Categories")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Asset Categories';
                        RunObject = Page "MCH Maint. Asset Category List";
                    }
                    action("Units of Measure")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Units of Measure';
                        RunObject = Page "Units of Measure";
                        RunPageMode = View;
                    }
                    action("AM Report Selection")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'AM Report Selection';
                        RunObject = Page "MCH AM Report Selection";
                    }
                    group("Journal Templates")
                    {
                        Caption = 'Journal Templates';
                        Image = Setup;
                        action("Maint. Journal Templates")
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Maint. Journal Templates';
                            RunObject = Page "MCH Maint. Jnl. Templates";
                        }
                        action("Usage Journal Templates")
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Usage Journal Templates';
                            RunObject = Page "MCH Usage Jnl. Templates";
                        }
                        action("Maint. Planning Wksh. Templates")
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Maint. Planning Wksh. Templates';
                            RunObject = Page "MCH AM Plan. Wksh. Templates";
                        }
                    }
                }
                group(Posting)
                {
                    Caption = 'Posting';
                    Image = Setup;
                    group(InternalPosting)
                    {
                        Caption = 'Internal';
                        Image = Setup;
                        action("AM Posting Setup")
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'AM Posting Setup';
                            RunObject = Page "MCH AM Posting Setup";
                        }
                        action("Asset Posting Groups")
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Asset Posting Groups';
                            RunObject = Page "MCH Maint. Asset Posting Grps";
                        }
                        action(Resources)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Resources';
                            RunObject = Page "Resource List";
                        }
                        action(Teams)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Teams';
                            RunObject = Page "MCH Maintenance Team List";
                        }
                    }
                    group(ExternalPosting)
                    {
                        Caption = 'External';
                        Image = Setup;
                        action("Spare Parts")
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Spare Parts';
                            RunObject = Page "MCH Maint. Spare Part List";
                        }
                        action(Trades)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Trades';
                            RunObject = Page "MCH Maintenance Trade List";
                        }
                        action("Maint. Costs")
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Maint. Costs';
                            RunObject = Page "MCH Maint. Cost List";
                        }
                    }
                }
                group("Maintenance Task")
                {
                    Caption = 'Maintenance Task';
                    Image = Setup;
                    action("Master Maint. Tasks")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Master Maint. Tasks';
                        RunObject = Page "MCH Master Maint. Task List";
                    }
                    action("Maint. Task Categories")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Maint. Task Categories';
                        RunObject = Page "MCH Maint. Task Categories";
                    }
                }
                group("Usage Monitor")
                {
                    Caption = 'Usage Monitor';
                    Image = Setup;
                    action("Master Usage Monitors")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Master Usage Monitors';
                        RunObject = Page "MCH Master Usage Monitors";
                    }
                    action("Usage Monitor Categories")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Usage Monitor Categories';
                        RunObject = Page "MCH Usage Monitor Categories";
                    }
                }
            }
        }
    }
}

