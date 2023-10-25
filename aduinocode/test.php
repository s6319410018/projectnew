<?php
// Include the connection script
require "connect.php";

// Check if the database connection is successful
if (!$con) {
    echo "Connection error";
} else {
    // Check if 'espkey' is provided in the POST data
    if (!empty($_POST['espkey'])) {
        $espkey = $_POST['espkey'];
        $espkey = mysqli_real_escape_string($con, $_POST['espkey']);

        date_default_timezone_set('Asia/Bangkok'); // Set the timezone

        $Date_Back_7 = date("Y-m-d", strtotime("-7 day"));

        $Date_Back_14 = date("Y-m-d", strtotime("-14 day"));

        $Date_Back_21 = date("Y-m-d", strtotime("-21 day"));

        $Date_Back_28 = date("Y-m-d", strtotime("-28 day"));

        $Time_Back_10 = date("H:i:s", strtotime("-10 minutes"));
        $Time_Back_20 = date("H:i:s", strtotime("-20 minutes"));
        $Time_Back_30 = date("H:i:s", strtotime("-30 minutes"));
        $Time_Back_40 = date("H:i:s", strtotime("-40 minutes"));
        $Time_Back_50 = date("H:i:s", strtotime("-50 minutes"));
        $Time_Back_60 = date("H:i:s", strtotime("-60 minutes"));
        $Time_Back_70 = date("H:i:s", strtotime("-70 minutes"));
        $Time_Back_80 = date("H:i:s", strtotime("-80 minutes"));

        $Date_Back_7 = (string)$Date_Back_7;

        $Date_Back_14 = (string)$Date_Back_14;

        $Date_Back_21 = (string)$Date_Back_21;

        $Date_Back_28 = (string)$Date_Back_28;

        $Time_Back_10 = (string)$Time_Back_10;
        $Time_Back_20 = (string)$Time_Back_20;
        $Time_Back_30 = (string)$Time_Back_30;
        $Time_Back_40 = (string)$Time_Back_40;
        $Time_Back_50 = (string)$Time_Back_50;
        $Time_Back_60 = (string)$Time_Back_60;
        $Time_Back_70 = (string)$Time_Back_70;
        $Time_Back_80 = (string)$Time_Back_80;


        $sqlUserID = "SELECT user_Id FROM user_tb WHERE user_Product_ID='$espkey'";

        $resultUserID = $con->query($sqlUserID);

        if ($resultUserID === false) {
            echo "ไม่สามารถดึงข้อมูลได้";
        } elseif ($resultUserID->num_rows > 0) {
            $rowUserID = $resultUserID->fetch_assoc();


            $sqlRealtimeControl = "SELECT control_Date_On, control_Time_On, control_Date_OFF, control_Time_OFF,
            control_Solenoid, control_Ai
            FROM control_solenoid_tb, control_time_tb, control_ai_tb
            WHERE control_time_tb.user_control_Time_Id='$rowUserID[user_Id]'
            AND control_solenoid_tb.user_control_Solenoid_Id ='$rowUserID[user_Id]'
            AND control_ai_tb.user_control_Ai_Id='$rowUserID[user_Id]' ";



            $sqlLasttimeData = "SELECT Product_Details_Day_Water_Use,Product_Details_Month_Water_Use FROM product_details_tb WHERE product_key= '$espkey' ORDER BY Product_Details_Month_Id DESC LIMIT 1";

            //ดึงข้อมูลย้อนหลัง 1 สัปดาห์
            $result_sql_time_back_10_1_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_7' AND time='$Time_Back_10' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_20_1_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_7' AND time='$Time_Back_20' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_30_1_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_7' AND time='$Time_Back_30' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_40_1_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_7' AND time='$Time_Back_40' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_50_1_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_7' AND time='$Time_Back_50' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_60_1_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_7' AND time='$Time_Back_60' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_70_1_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_7' AND time='$Time_Back_70' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_80_1_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_7' AND time='$Time_Back_80' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");


            //ดึงข้อมูลย้อนหลัง 2 สัปดาห์
            $result_sql_time_back_10_2_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_14' AND time='$Time_Back_10' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_20_2_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_14' AND time='$Time_Back_20' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_30_2_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_14' AND time='$Time_Back_30' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_40_2_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_14' AND time='$Time_Back_40' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_50_2_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_14' AND time='$Time_Back_50' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_60_2_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_14' AND time='$Time_Back_60' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_70_2_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_14' AND time='$Time_Back_70' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_80_2_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_14' AND time='$Time_Back_80' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");

            //ดึงข้อมูลย้อนหลัง 3 สัปดาห์
            $result_sql_time_back_10_3_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_21' AND time='$Time_Back_10' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_20_3_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_21' AND time='$Time_Back_20' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_30_3_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_21' AND time='$Time_Back_30' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_40_3_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_21' AND time='$Time_Back_40' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_50_3_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_21' AND time='$Time_Back_50' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_60_3_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_21' AND time='$Time_Back_60' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_70_3_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_21' AND time='$Time_Back_70' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_80_3_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_21' AND time='$Time_Back_80' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");

            //ดึงข้อมูลย้อนหลัง 4 สัปดาห์
            $result_sql_time_back_10_4_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_28' AND time='$Time_Back_10' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_20_4_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_28' AND time='$Time_Back_20' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_30_4_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_28' AND time='$Time_Back_30' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_40_4_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_28' AND time='$Time_Back_40' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_50_4_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_28' AND time='$Time_Back_50' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_60_4_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_28' AND time='$Time_Back_60' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_70_4_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_28' AND time='$Time_Back_70' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");
            $result_sql_time_back_80_4_week = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_Back_28' AND time='$Time_Back_80' ORDER BY Product_Details_Month_Water_Use DESC LIMIT 1");



            //ข้อมูลย้อนหลัง 4 สัปดาห์ นำมาเฉลี่ยรายชั่วโมง
            $average_4_week_time_back_10 = array(
                $result_sql_time_back_10_1_week->num_rows > 0 ? $result_sql_time_back_10_1_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_10_2_week->num_rows > 0 ? $result_sql_time_back_10_2_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_10_3_week->num_rows > 0 ? $result_sql_time_back_10_3_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_10_4_week->num_rows > 0 ? $result_sql_time_back_10_4_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0

            );
            $average_4_week_time_back_20 = array(
                $result_sql_time_back_20_1_week->num_rows > 0 ? $result_sql_time_back_20_1_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_20_2_week->num_rows > 0 ? $result_sql_time_back_20_2_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_20_3_week->num_rows > 0 ? $result_sql_time_back_20_3_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_20_4_week->num_rows > 0 ? $result_sql_time_back_20_4_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0
            );
            $average_4_week_time_back_30 = array(
                $result_sql_time_back_30_1_week->num_rows > 0 ? $result_sql_time_back_30_1_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_30_2_week->num_rows > 0 ? $result_sql_time_back_30_2_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_30_3_week->num_rows > 0 ? $result_sql_time_back_30_3_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_30_4_week->num_rows > 0 ? $result_sql_time_back_30_4_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0
            );
            $average_4_week_time_back_40 = array(
                $result_sql_time_back_40_1_week->num_rows > 0 ? $result_sql_time_back_40_1_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_40_2_week->num_rows > 0 ? $result_sql_time_back_40_2_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_40_3_week->num_rows > 0 ? $result_sql_time_back_40_3_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_40_4_week->num_rows > 0 ? $result_sql_time_back_40_4_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0
            );
            $average_4_week_time_back_50 = array(
                $result_sql_time_back_50_1_week->num_rows > 0 ? $result_sql_time_back_50_1_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_50_2_week->num_rows > 0 ? $result_sql_time_back_50_2_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_50_3_week->num_rows > 0 ? $result_sql_time_back_50_3_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_50_4_week->num_rows > 0 ? $result_sql_time_back_50_4_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0
            );
            $average_4_week_time_back_60 = array(
                $result_sql_time_back_60_1_week->num_rows > 0 ? $result_sql_time_back_60_1_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_60_2_week->num_rows > 0 ? $result_sql_time_back_60_2_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_60_3_week->num_rows > 0 ? $result_sql_time_back_60_3_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_60_4_week->num_rows > 0 ? $result_sql_time_back_60_4_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0
            );
            $average_4_week_time_back_70 = array(
                $result_sql_time_back_70_1_week->num_rows > 0 ? $result_sql_time_back_70_1_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_70_2_week->num_rows > 0 ? $result_sql_time_back_70_2_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_70_3_week->num_rows > 0 ? $result_sql_time_back_70_3_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_70_4_week->num_rows > 0 ? $result_sql_time_back_70_4_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0
            );
            $average_4_week_time_back_80 = array(
                $result_sql_time_back_80_1_week->num_rows > 0 ? $result_sql_time_back_80_1_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_80_2_week->num_rows > 0 ? $result_sql_time_back_80_2_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_80_3_week->num_rows > 0 ? $result_sql_time_back_80_3_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                $result_sql_time_back_80_4_week->num_rows > 0 ? $result_sql_time_back_80_4_week->fetch_assoc()["Product_Details_Month_Pressure"] : 0
            );


            //หาค่าเฉลี่ยรายรายชั่วโมง 4 สัปดาห์
            $x_bar_4_week_time_back_10 = array_sum($average_4_week_time_back_10) / count($average_4_week_time_back_10);
            $x_bar_4_week_time_back_20 = array_sum($average_4_week_time_back_20) / count($average_4_week_time_back_20);
            $x_bar_4_week_time_back_30 = array_sum($average_4_week_time_back_30) / count($average_4_week_time_back_30);
            $x_bar_4_week_time_back_40 = array_sum($average_4_week_time_back_40) / count($average_4_week_time_back_40);
            $x_bar_4_week_time_back_50 = array_sum($average_4_week_time_back_50) / count($average_4_week_time_back_50);
            $x_bar_4_week_time_back_60 = array_sum($average_4_week_time_back_60) / count($average_4_week_time_back_60);
            $x_bar_4_week_time_back_70 = array_sum($average_4_week_time_back_70) / count($average_4_week_time_back_70);
            $x_bar_4_week_time_back_80 = array_sum($average_4_week_time_back_80) / count($average_4_week_time_back_80);


            //ถ้มมีค่ามากกว่าศูนย์รีเทิร์นค่า
            $value_4_week = array(
                $x_bar_4_week_time_back_10 > 0 ? $x_bar_4_week_time_back_10 : 0,
                $x_bar_4_week_time_back_20 > 0 ? $x_bar_4_week_time_back_20 : 0,
                $x_bar_4_week_time_back_30 > 0 ? $x_bar_4_week_time_back_30 : 0,
                $x_bar_4_week_time_back_40 > 0 ? $x_bar_4_week_time_back_40 : 0,
                $x_bar_4_week_time_back_50 > 0 ? $x_bar_4_week_time_back_50 : 0,
                $x_bar_4_week_time_back_60 > 0 ? $x_bar_4_week_time_back_60 : 0,
                $x_bar_4_week_time_back_70 > 0 ? $x_bar_4_week_time_back_70 : 0,
                $x_bar_4_week_time_back_70 > 0 ? $x_bar_4_week_time_back_80 : 0,

            );

            //นำค่าที่ได้มาหาค่าเฉลี่ย
            $x_bar_4_week = array_sum($value_4_week) / count($value_4_week);

            $squaredDifferences = array_map(function ($value_4_week) use ($x_bar_4_week) {
                return ($value_4_week - $x_bar_4_week) ** 2;
            }, $value_4_week);
            $variance = array_sum($squaredDifferences) / (count($squaredDifferences) - 1);
            $standardDeviation = sqrt($variance);

            //ขอบบน
            $resultSDPlus =   $x_bar_4_week + $standardDeviation;
            //ขอบล่าง
            $resultSDMinus =   $x_bar_4_week - $standardDeviation;

            $result_sqlRealTimeControl = $con->query($sqlRealtimeControl);
            $result_sqlLasttimedata = $con->query($sqlLasttimeData);


            if ($result_sqlRealTimeControl === false && $result_sqlLasttimedata == false) {
                echo "ไม่สามารถหาข้อมูลได้";
            } elseif ($resultSDMinus == 0 && $result_sqlRealTimeControl->num_rows > 0 && $result_sqlLasttimedata->num_rows > 0) {


                $Date_january_back_7day = date("2023-01-d", strtotime("-7 days"));
                $Date_january_back_14day = date("2023-01-d", strtotime("-7 days"));
                $Date_january_back_21day = date("2023-01-d", strtotime("-7 days"));
                $Date_january_back_28day = date("2023-01-d", strtotime("-7 days"));
                $Time_Back_10_format = date("H:i:00", strtotime("-10 minutes"));
                $Time_Back_20_format = date("H:i:00", strtotime("-20 minutes"));
                $Time_Back_30_format = date("H:i:00", strtotime("-30 minutes"));
                $Time_Back_40_format = date("H:i:00", strtotime("-40 minutes"));
                $Time_Back_50_format = date("H:i:00", strtotime("-50 minutes"));
                $Time_Back_60_format = date("H:i:00", strtotime("-60 minutes"));
                $Time_Back_70_format = date("H:i:00", strtotime("-70 minutes"));
                $Time_Back_80_format = date("H:i:00", strtotime("-80 minutes"));

                $Date_january_back_7day = (string)$Date_january_back_7day;
                $Date_january_back_14day = (string)$Date_january_back_14day;
                $Date_january_back_21day = (string)$Date_january_back_21day;
                $Date_january_back_28day = (string)$Date_january_back_28day;

                $Time_Back_10_format = (string)$Time_Back_10_format;
                $Time_Back_20_format = (string)$Time_Back_20_format;
                $Time_Back_30_format = (string)$Time_Back_30_format;
                $Time_Back_40_format = (string)$Time_Back_40_format;
                $Time_Back_50_format = (string)$Time_Back_50_format;
                $Time_Back_60_format = (string)$Time_Back_60_format;
                $Time_Back_70_format = (string)$Time_Back_70_format;
                $Time_Back_80_format = (string)$Time_Back_80_format;


                //ดึงข้อมูลย้อนหลัง 1 สัปดาห์
                $result_sql_time_back_10_1_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_7day' AND time='$Time_Back_10_format' ORDER BY  Product_Details_Month_Id  DESC LIMIT 1");
                $result_sql_time_back_20_1_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_7day' AND time='$Time_Back_20_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_30_1_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_7day' AND time='$Time_Back_30_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_40_1_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_7day' AND time='$Time_Back_40_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_50_1_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_7day' AND time='$Time_Back_50_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_60_1_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_7day' AND time='$Time_Back_60_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_70_1_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_7day' AND time='$Time_Back_70_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_80_1_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_7day' AND time='$Time_Back_80_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");


                //ดึงข้อมูลย้อนหลัง 2 สัปดาห์
                $result_sql_time_back_10_2_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_14day' AND time='$Time_Back_10_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_20_2_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_14day' AND time='$Time_Back_20_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_30_2_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_14day' AND time='$Time_Back_30_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_40_2_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_14day' AND time='$Time_Back_40_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_50_2_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_14day' AND time='$Time_Back_50_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_60_2_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_14day' AND time='$Time_Back_60_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_70_2_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_14day' AND time='$Time_Back_70_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_80_2_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_14day' AND time='$Time_Back_80_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");

                //ดึงข้อมูลย้อนหลัง 3 สัปดาห์
                $result_sql_time_back_10_3_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_21day' AND time='$Time_Back_10_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_20_3_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_21day' AND time='$Time_Back_20_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_30_3_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_21day' AND time='$Time_Back_30_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_40_3_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_21day' AND time='$Time_Back_40_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_50_3_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_21day' AND time='$Time_Back_50_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_60_3_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_21day' AND time='$Time_Back_60_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_70_3_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_21day' AND time='$Time_Back_70_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_80_3_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_21day' AND time='$Time_Back_80_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");

                //ดึงข้อมูลย้อนหลัง 4 สัปดาห์
                $result_sql_time_back_10_4_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_28day' AND time='$Time_Back_10_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_20_4_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_28day' AND time='$Time_Back_20_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_30_4_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_28day' AND time='$Time_Back_30_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_40_4_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_28day' AND time='$Time_Back_40_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_50_4_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_28day' AND time='$Time_Back_50_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_60_4_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_28day' AND time='$Time_Back_60_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_70_4_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_28day' AND time='$Time_Back_70_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");
                $result_sql_time_back_80_4_week_january  = $con->query("SELECT Product_Details_Month_Pressure FROM product_details_tb WHERE date='$Date_january_back_28day' AND time='$Time_Back_80_format' ORDER BY Product_Details_Month_Id DESC LIMIT 1");



                //ข้อมูลย้อนหลัง 4 สัปดาห์ นำมาเฉลี่ยรายชั่วโมง
                $average_4_week_time_back_10_january = array(
                    $result_sql_time_back_10_1_week_january->num_rows > 0 ? $result_sql_time_back_10_1_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_10_2_week_january->num_rows > 0 ? $result_sql_time_back_10_2_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_10_3_week_january->num_rows > 0 ? $result_sql_time_back_10_3_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_10_4_week_january->num_rows > 0 ? $result_sql_time_back_10_4_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0

                );
                $average_4_week_time_back_20_january = array(
                    $result_sql_time_back_20_1_week_january->num_rows > 0 ? $result_sql_time_back_20_1_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_20_2_week_january->num_rows > 0 ? $result_sql_time_back_20_2_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_20_3_week_january->num_rows > 0 ? $result_sql_time_back_20_3_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_20_4_week_january->num_rows > 0 ? $result_sql_time_back_20_4_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0
                );
                $average_4_week_time_back_30_january = array(
                    $result_sql_time_back_30_1_week_january->num_rows > 0 ? $result_sql_time_back_30_1_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_30_2_week_january->num_rows > 0 ? $result_sql_time_back_30_2_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_30_3_week_january->num_rows > 0 ? $result_sql_time_back_30_3_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_30_4_week_january->num_rows > 0 ? $result_sql_time_back_30_4_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0
                );
                $average_4_week_time_back_40_january = array(
                    $result_sql_time_back_40_1_week_january->num_rows > 0 ? $result_sql_time_back_40_1_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_40_2_week_january->num_rows > 0 ? $result_sql_time_back_40_2_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_40_3_week_january->num_rows > 0 ? $result_sql_time_back_40_3_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_40_4_week_january->num_rows > 0 ? $result_sql_time_back_40_4_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0
                );
                $average_4_week_time_back_50_january = array(
                    $result_sql_time_back_50_1_week_january->num_rows > 0 ? $result_sql_time_back_50_1_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_50_2_week_january->num_rows > 0 ? $result_sql_time_back_50_2_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_50_3_week_january->num_rows > 0 ? $result_sql_time_back_50_3_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_50_4_week_january->num_rows > 0 ? $result_sql_time_back_50_4_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0
                );
                $average_4_week_time_back_60_january = array(
                    $result_sql_time_back_60_1_week_january->num_rows > 0 ? $result_sql_time_back_60_1_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_60_2_week_january->num_rows > 0 ? $result_sql_time_back_60_2_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_60_3_week_january->num_rows > 0 ? $result_sql_time_back_60_3_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_60_4_week_january->num_rows > 0 ? $result_sql_time_back_60_4_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0
                );
                $average_4_week_time_back_70_january = array(
                    $result_sql_time_back_70_1_week_january->num_rows > 0 ? $result_sql_time_back_70_1_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_70_2_week_january->num_rows > 0 ? $result_sql_time_back_70_2_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_70_3_week_january->num_rows > 0 ? $result_sql_time_back_70_3_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_70_4_week_january->num_rows > 0 ? $result_sql_time_back_70_4_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0
                );
                $average_4_week_time_back_80_january = array(
                    $result_sql_time_back_80_1_week_january->num_rows > 0 ? $result_sql_time_back_80_1_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_80_2_week_january->num_rows > 0 ? $result_sql_time_back_80_2_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_80_3_week_january->num_rows > 0 ? $result_sql_time_back_80_3_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0,
                    $result_sql_time_back_80_4_week_january->num_rows > 0 ? $result_sql_time_back_80_4_week_january->fetch_assoc()["Product_Details_Month_Pressure"] : 0
                );


                //หาค่าเฉลี่ยรายรายชั่วโมง 4 สัปดาห์
                $x_bar_4_week_time_back_10_january = array_sum($average_4_week_time_back_10_january) / count($average_4_week_time_back_10_january);
                $x_bar_4_week_time_back_20_january = array_sum($average_4_week_time_back_20_january) / count($average_4_week_time_back_20_january);
                $x_bar_4_week_time_back_30_january = array_sum($average_4_week_time_back_30_january) / count($average_4_week_time_back_30_january);
                $x_bar_4_week_time_back_40_january = array_sum($average_4_week_time_back_40_january) / count($average_4_week_time_back_40_january);
                $x_bar_4_week_time_back_50_january = array_sum($average_4_week_time_back_50_january) / count($average_4_week_time_back_50_january);
                $x_bar_4_week_time_back_60_january = array_sum($average_4_week_time_back_60_january) / count($average_4_week_time_back_60_january);
                $x_bar_4_week_time_back_70_january = array_sum($average_4_week_time_back_70_january) / count($average_4_week_time_back_70_january);
                $x_bar_4_week_time_back_80_january = array_sum($average_4_week_time_back_80_january) / count($average_4_week_time_back_80_january);


                //ถ้มมีค่ามากกว่าศูนย์รีเทิร์นค่า
                $value_4_week_january = array(
                    $x_bar_4_week_time_back_10_january > 0 ? $x_bar_4_week_time_back_10_january : 0,
                    $x_bar_4_week_time_back_20_january > 0 ? $x_bar_4_week_time_back_20_january : 0,
                    $x_bar_4_week_time_back_30_january > 0 ? $x_bar_4_week_time_back_30_january : 0,
                    $x_bar_4_week_time_back_40_january > 0 ? $x_bar_4_week_time_back_40_january : 0,
                    $x_bar_4_week_time_back_50_january > 0 ? $x_bar_4_week_time_back_50_january : 0,
                    $x_bar_4_week_time_back_60_january > 0 ? $x_bar_4_week_time_back_60_january : 0,
                    $x_bar_4_week_time_back_70_january > 0 ? $x_bar_4_week_time_back_70_january : 0,
                    $x_bar_4_week_time_back_70_january > 0 ? $x_bar_4_week_time_back_80_january : 0,

                );

                //นำค่าที่ได้มาหาค่าเฉลี่ย
                $x_bar_4_week_january = array_sum($value_4_week_january) / count($value_4_week_january);

                $squaredDifferences_january = array_map(function ($value_4_week_january) use ($x_bar_4_week_january) {
                    return ($value_4_week_january - $x_bar_4_week_january) ** 2;
                }, $value_4_week_january);
                $variance_january = array_sum($squaredDifferences_january) / (count($squaredDifferences_january) - 1);
                $standardDeviation_january = sqrt($variance_january);

                //ขอบบน
                $resultSDPlus_january =  $x_bar_4_week_january + $standardDeviation_january;
                //ขอบล่าง
                $resultSDMinus_january =  $x_bar_4_week_january - $standardDeviation_january;
                $resultSDMinus_january = round($resultSDMinus_january, 2);

                $result_sqlRealTimeControl = $con->query($sqlRealtimeControl);
                $result_sqlLasttimedata = $con->query($sqlLasttimeData);
                $row = $result_sqlRealTimeControl->fetch_assoc();
                $row1 = $result_sqlLasttimedata->fetch_assoc();

                function formatData(
                    $control_Date_On,
                    $control_Time_On,
                    $control_Date_OFF,
                    $control_Time_OFF,
                    $control_Solenoid,
                    $control_Ai,
                    $resultSDMinus_january,
                    $DataLastDAY,
                    $DataLastMONTH
                ) {
                    // Format time to HH:MM format
                    $formatted_control_Time_On = date("H:i", strtotime($control_Time_On));
                    $formatted_control_Time_Off = date("H:i", strtotime($control_Time_OFF));

                    $formattedData = "$control_Date_On,$formatted_control_Time_On,$control_Date_OFF,$formatted_control_Time_Off," .
                        "$control_Solenoid,$control_Ai,$resultSDMinus_january,$DataLastDAY,$DataLastMONTH";
                    return $formattedData;
                }



                $formattedData = formatData(
                    $row["control_Date_On"],
                    $row["control_Time_On"],
                    $row["control_Date_OFF"],
                    $row["control_Time_OFF"],
                    $row["control_Solenoid"],
                    $row["control_Ai"],
                    $resultSDMinus_january,
                    $row1["Product_Details_Day_Water_Use"],
                    $row1["Product_Details_Month_Water_Use"],

                );

                echo $formattedData;
            } elseif ($resultSDMinus != 0 && $result_sqlRealTimeControl->num_rows > 0 && $result_sqlLasttimedata->num_rows > 0) {


                $row = $result_sqlRealTimeControl->fetch_assoc();
                $row1 = $result_sqlLasttimedata->fetch_assoc();

                function formatData(
                    $control_Date_On,
                    $control_Time_On,
                    $control_Date_OFF,
                    $control_Time_OFF,
                    $control_Solenoid,
                    $control_Ai,
                    $resultSDMinus,
                    $DataLastDAY,
                    $DataLastMONTH
                ) {
                    // Format time to HH:MM format
                    $formatted_control_Time_On = date("H:i", strtotime($control_Time_On));
                    $formatted_control_Time_Off = date("H:i", strtotime($control_Time_OFF));

                    $formattedData = "$control_Date_On,$formatted_control_Time_On,$control_Date_OFF,$formatted_control_Time_Off," .
                        "$control_Solenoid,$control_Ai,$resultSDMinus,$DataLastDAY,$DataLastMONTH";
                    return $formattedData;
                }
                $formattedData = formatData(
                    $row["control_Date_On"],
                    $row["control_Time_On"],
                    $row["control_Date_OFF"],
                    $row["control_Time_OFF"],
                    $row["control_Solenoid"],
                    $row["control_Ai"],
                    $resultSDMinus,
                    $row1["Product_Details_Day_Water_Use"],
                    $row1["Product_Details_Month_Water_Use"],

                );

                echo $formattedData;
            } else {
                echo "0 results";
            }
        } else {
            echo "No matching records found";
        }
    } else {
        echo "No data from ESP8266 (empty 'espkey' in POST request)";
    }

    // Close the database connection
    $con->close();
}
