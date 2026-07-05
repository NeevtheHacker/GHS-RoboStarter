// =============================================================================
//  GHS Robotics — TEACHING STARTER  (derived from last season's `cardbot`)
//  PROS + LemLib · VEX V5RC
//
//  The SIMPLE version for the summer sessions: just the drivetrain, odometry,
//  driving, and one tiny autonomous — using LemLib's built-in arcade drive.
//  The full competition code lives in `cardbot` (reference for Week 2).
//
//  Section labels map to the Code Track days:
//     Day 3 = CONFIG + DEVICES + chassis setup
//     Day 4 = ODOMETRY sensors
//     Day 5 = autonomous() using odometry
//  Values marked  <-- SET  come from the actual robot you build.
// =============================================================================

#include "main.h"
#include "lemlib/api.hpp"   // IWYU pragma: keep
using namespace pros;

// ==================== CONFIG (Day 3) ========================================
// Drive motor ports (negative = reversed). These are last season's ports.
constexpr int8_t L_FRONT_PORT = -20, L_BACK_PORT = -19, L_BACK_STACK_PORT = 18;   // <-- SET
constexpr int8_t R_FRONT_PORT =  10, R_BACK_PORT =   9, R_BACK_STACK_PORT = -8;   // <-- SET

// Odometry ports
constexpr int8_t IMU_PORT = 16;                       // <-- SET
constexpr int8_t VERTICAL_ROTATION_SENSOR_PORT   = 3; // <-- SET
constexpr int8_t HORIZONTAL_ROTATION_SENSOR_PORT = 2; // <-- SET

// Drivetrain geometry
constexpr double TRACK_WIDTH = 12.25;   // inches   <-- SET

// ==================== DEVICES (Day 3) =======================================
Controller master(E_CONTROLLER_MASTER);
MotorGroup leftDrive ({L_FRONT_PORT, L_BACK_PORT, L_BACK_STACK_PORT}, v5::MotorGears::green);
MotorGroup rightDrive({R_FRONT_PORT, R_BACK_PORT, R_BACK_STACK_PORT}, v5::MotorGears::green);

// ==================== LEMLIB DRIVETRAIN (Day 3) =============================
lemlib::Drivetrain drivetrain(&leftDrive, &rightDrive,
    TRACK_WIDTH,
    lemlib::Omniwheel::NEW_4,   // 4" omni wheels   <-- SET
    300,                        // drivetrain RPM   <-- SET
    2);                         // horizontal drift

// ==================== ODOMETRY (Day 4) ======================================
pros::Imu imu(IMU_PORT);
pros::Rotation vertical_encoder(VERTICAL_ROTATION_SENSOR_PORT);
pros::Rotation horizontal_encoder(HORIZONTAL_ROTATION_SENSOR_PORT);

// A tracking wheel = an encoder + its wheel size + its offset from robot center.
lemlib::TrackingWheel vertical_tracking_wheel  (&vertical_encoder,   lemlib::Omniwheel::NEW_275, 0); // <-- SET offset
lemlib::TrackingWheel horizontal_tracking_wheel(&horizontal_encoder, lemlib::Omniwheel::NEW_2,   4); // <-- SET offset

lemlib::OdomSensors sensors(
    &vertical_tracking_wheel,   // tracks forward/back
    nullptr,
    &horizontal_tracking_wheel, // tracks side-to-side
    nullptr,
    &imu);                      // tracks heading

// ==================== PID (Day 5 — for autonomous only) =====================
// Last season's tuned values. They'll be re-tuned for the new robot in Week 2.
lemlib::ControllerSettings lateral_pid(7.441, 0, 58.33, 3, 1, 100, 3, 500, 20);
lemlib::ControllerSettings angular_pid(5.5,   0, 57.63, 3, 1, 100, 3, 500,  0);

lemlib::Chassis chassis(drivetrain, lateral_pid, angular_pid, sensors);

// ==================== PROS LIFECYCLE ========================================
void initialize() {
    pros::lcd::initialize();
    chassis.calibrate();                 // calibrates the IMU + odometry
    // Show the robot's estimated position on the brain screen (Day 5 payoff):
    pros::Task screen([&](){
        while (true) {
            pros::lcd::print(0, "X: %.1f", chassis.getPose().x);
            pros::lcd::print(1, "Y: %.1f", chassis.getPose().y);
            pros::lcd::print(2, "Heading: %.1f", chassis.getPose().theta);
            pros::delay(50);
        }
    });
}

void disabled() {}
void competition_initialize() {}

// ==================== AUTONOMOUS (Day 5) ====================================
// A tiny odometry demo: start at origin, drive forward 24", then turn to 90.
void autonomous() {
    chassis.setPose(0, 0, 0);
    chassis.moveToPoint(0, 24, 4000);    // drive to (0,24) within 4s
    chassis.turnToHeading(90, 2000);     // face 90 degrees within 2s
}

// ==================== DRIVER CONTROL (Day 3–4) ==============================
void opcontrol() {
    while (true) {
        int throttle = master.get_analog(E_CONTROLLER_ANALOG_LEFT_Y);   // forward/back
        int turn     = master.get_analog(E_CONTROLLER_ANALOG_RIGHT_X);  // steering

        chassis.arcade(throttle, turn);   // LemLib's built-in arcade drive

        pros::delay(10);
    }
}