/*
* (c) Copyright, Real-Time Innovations, 2012.  All rights reserved.
* RTI grants Licensee a license to use, modify, compile, and create derivative
* works of the software solely for use with RTI Connext DDS. Licensee may
* redistribute copies of the software provided that all such copies are subject
* to this license. The software is provided "as is", with no warranty of any
* type, including any warranty for fitness for any purpose. RTI is under no
* obligation to maintain or support the software. RTI shall not be liable for
* any incidental or consequential damages arising out of the use or inability
* to use the software.
*/
/** ================================================================
 * ptc_demo.cxx
 * Publishes ROS2 PointCloud2 data type for viewing in ROS2 RViz2
 **/
#include <algorithm>
#include <iostream>
#include <dds/pub/ddspub.hpp>
#include <dds/core/ddscore.hpp>
#include "sensor_msgs/msg/PointCloud2Plugin.hpp"
#include <rti/util/util.hpp>                // for sleep()

/** ----------------------------------------------------------------
 * animatePoints()
 * update the position data in the pointcloud
 **/
void animatePoints(float *ptcData, int point_count)
{
    static bool once = true;
    static struct mvect {
        float   xv;
        float   yv;
        float   zv;
    } *mva = NULL;

    if (once) {
        // create array of random vectors to move points along
        mva = (struct mvect *)malloc(point_count * sizeof(struct mvect));
        for (int i = 0; i < point_count; i++) {
            mva[i].xv = ((static_cast<float>(rand() % 400)) / 2000) - 0.1f;
            mva[i].yv = ((static_cast<float>(rand() % 400)) / 2000) - 0.1f;
            mva[i].zv = ((static_cast<float>(rand() % 400)) / 2000) - 0.1f;
        }
        once = false;
    }
    // move each point according to their random vectors (created above), bounce off of walls (10x10x10)
    for (int i = 0; i < point_count; i++)
    {
        float *pBase = (ptcData + (i*4));
        // X
        *(pBase + 0) = (*(pBase + 0) + mva[i].xv);
        if (*(pBase + 0) > 5.0f) {
            *(pBase + 0) = -(*(pBase + 0) - 10.0f);
            mva[i].xv *= -1;
        }
        else if (*(pBase + 0) < -5.0f) {
            *(pBase + 0) = -(*(pBase + 0) + 10.0f);
            mva[i].xv *= -1;
        }

        // Y
        *(pBase + 1) = (*(pBase + 1) + mva[i].yv);
        if (*(pBase + 1) > 5.0f) {
            *(pBase + 1) = -(*(pBase + 1) - 10.0f);
            mva[i].yv *= -1;
        }
        else if (*(pBase + 1) < -5.0f) {
            *(pBase + 1) = -(*(pBase + 1) + 10.0f);
            mva[i].yv *= -1;
        }

        // Z
        *(pBase + 2) = (*(pBase + 2) + mva[i].zv);
        if (*(pBase + 2) > 10.0f) {
            *(pBase + 2) = -(*(pBase + 2) - 20.0f);
            mva[i].zv *= -1;
        }
        else if (*(pBase + 2) < 0.0f) {
            *(pBase + 2) = -(*(pBase + 2));
            mva[i].zv *= -1;
        }
    }
    return;
}



/** ----------------------------------------------------------------
 * participant_main()
 **/
void participant_main(int domain_id)
{
    // Create a DomainParticipant with default Qos
    dds::domain::DomainParticipant participant(domain_id);

    // create a topic and publisher/dataWriter for PointCloud2 publication
    dds::topic::Topic<sensor_msgs::msg::PointCloud2> ptc_topic(participant, "rt/ptcloud_test");
    dds::pub::DataWriter<sensor_msgs::msg::PointCloud2> ptc_writer(dds::pub::Publisher(participant), ptc_topic);

    // create and init a sample
    sensor_msgs::msg::PointCloud2 ptc_sample;
    ptc_sample.header().frame_id("map");
    ptc_sample.point_step(16);
    ptc_sample.row_step(1);
    ptc_sample.is_dense(true);
    ptc_sample.fields().resize(4);
    ptc_sample.fields().at(0).name("x");
    ptc_sample.fields().at(0).offset(0);
    ptc_sample.fields().at(0).datatype(7);  // 2=UINT8, 7=float32
    ptc_sample.fields().at(0).count(1);
    ptc_sample.fields().at(1).name("y");
    ptc_sample.fields().at(1).offset(4);
    ptc_sample.fields().at(1).datatype(7);
    ptc_sample.fields().at(1).count(1);
    ptc_sample.fields().at(2).name("z");
    ptc_sample.fields().at(2).offset(8);
    ptc_sample.fields().at(2).datatype(7);
    ptc_sample.fields().at(2).count(1);
    ptc_sample.fields().at(3).name("rgb");
    ptc_sample.fields().at(3).offset(12);
    ptc_sample.fields().at(3).datatype(7);
    ptc_sample.fields().at(3).count(1);
    int point_count = 500;
    ptc_sample.height(1);
    ptc_sample.width(point_count);
    ptc_sample.data().resize(point_count * 4 * 4); // each point needs: 4(xyzc) x 4 bytes(float32)
    float * ptcData = reinterpret_cast<float *>(ptc_sample.data().data());
    for(int i=0 ; i<point_count ; i++)
    {
        float *pBase = (ptcData + (i*4));
        *(pBase + 0) = static_cast<float>(((rand() % 1000) / 100.0f) - 5.0f);  // X: -5 to 5
        *(pBase + 1) = static_cast<float>(((rand() % 1000) / 100.0f) - 5.0f);  // Y: -5 to 5
        *(pBase + 2) = static_cast<float>((rand() % 1000) / 100.0f);           // Z:  0 to 10
        *(pBase + 3) = static_cast<float>(
            (((rand() % 255) | 0x25) * 65536) +
            (((rand() % 255) | 0x25) *   256) +
            (( rand() % 255) | 0x25));                          // RGB color of the point
    }
    // main loop --------------------------------------------------------------
    for (int wcount = 0; 1; wcount++) {
        ptc_writer.write(ptc_sample);
        rti::util::sleep(dds::core::Duration(0, 100000000));
        animatePoints(ptcData, point_count);
    }
}

/** ----------------------------------------------------------------
 * main()
 **/
int main(int argc, char *argv[])
{
    int domain_id = 0;
    if (argc >= 2) {
        domain_id = atoi(argv[1]);
    }
    
    try {
        participant_main(domain_id);
    }
    catch (const std::exception& ex) {        // This will catch DDS exceptions
        std::cerr << "Exception in participant_main(): " << ex.what() << std::endl;
        return -1;
    }
    return 0;
}