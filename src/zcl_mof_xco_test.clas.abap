CLASS zcl_mof_xco_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES: if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_mof_xco_test IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA: lv_xco_gen_id TYPE c LENGTH 3 VALUE 'MOF'.
    DATA(lo_package) = xco_cp_abap_repository=>package->for( |Z{ lv_xco_gen_id }_XCO_GEN| ).
    DATA(lv_transport_target) = lo_package->read(
      )-property-transport_layer->get_transport_target(
      )->value.

    DATA(lo_transport_request) = xco_cp_cts=>transports->workbench( lv_transport_target
      )->create_request( 'Test XCO TR' ).

    DATA(lo_put_operation) = xco_cp_generation=>environment->dev_system( lo_transport_request->value
      )->create_put_operation( ).

    DATA(lo_domain) = lo_put_operation->for-doma->add_object( |Z{ lv_xco_gen_id }_XCO_WORKORDER_ID|
      )->set_package( lo_package->name
      )->create_form_specification( ).
    lo_domain->set_short_description( 'XCO Domain Workorder ID' ).
    lo_domain->set_format( xco_cp_abap_dictionary=>built_in_type->char( 10 ) ).

    DATA(lo_data_elem) = lo_put_operation->for-dtel->add_object( |Z{ lv_xco_gen_id }_XCO_WORKORDER_ID|
      )->set_package( lo_package->name
      )->create_form_specification( ).
    lo_data_elem->set_short_description( 'XCO Data Element Workorder ID' ).
    lo_data_elem->set_data_type( xco_cp_abap_dictionary=>domain( |Z{ lv_xco_gen_id }_XCO_WORKORDER_ID| ) ).

    DATA(lo_database_table) = lo_put_operation->for-tabl-for-database_table->add_object( |Z{ lv_xco_gen_id }_XCO_WRKORD|
      )->set_package( lo_package->name
      )->create_form_specification( ).
    lo_database_table->set_short_description( 'XCO Work Order Table' ).
    lo_database_table->set_delivery_class( xco_cp_database_table=>delivery_class->l ).
    lo_database_table->set_data_maintenance( xco_cp_database_table=>data_maintenance->allowed ).
    lo_database_table->add_field( 'CLIENT' )->set_type( xco_cp_abap_dictionary=>built_in_type->clnt
      )->set_key_indicator(
      )->set_not_null( ).
    lo_database_table->add_field( 'WORKORDER_ID' )->set_type( xco_cp_abap_dictionary=>data_element( |Z{ lv_xco_gen_id }_XCO_WORKORDER_ID| )
      )->set_key_indicator(
      )->set_not_null( ).
    lo_database_table->add_field( 'DESCRIPTION' )->set_type( xco_cp_abap_dictionary=>built_in_type->char( 30 ) ).


    DATA(lo_wo_class) = lo_put_operation->for-clas->add_object( |ZCL_{ lv_xco_gen_id }_XCO_WRKORD|
      )->set_package( lo_package->name
      )->create_form_specification( ).
    lo_wo_class->set_short_description( 'XCO Work Order class' ).
    lo_wo_class->definition->add_interface( 'IF_OO_ADT_CLASSRUN' ).
    lo_wo_class->implementation->add_method( 'IF_OO_ADT_CLASSRUN~MAIN'
      )->set_source( VALUE #(
        ( |SELECT * FROM Z{ lv_xco_gen_id }_XCO_WRKORD INTO TABLE @DATA(lt_workorders).| )
        ( |DATA(lv_num_workorders) = lines( lt_workorders ).| )
        ( |out->write( \|Num. of workorders: \{ lines( lt_workorders ) \}\| ). | )
      ) ).

    lo_put_operation->execute( ).

  ENDMETHOD.

ENDCLASS.

