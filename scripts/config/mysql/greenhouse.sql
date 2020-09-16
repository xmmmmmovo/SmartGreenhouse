/*
 Navicat Premium Data Transfer

 Source Server         : 腾讯云
 Source Server Type    : MySQL
 Source Server Version : 50718
 Source Host           : cdb-rshg0xgs.cd.tencentcdb.com:10092
 Source Schema         : greenhouse

 Target Server Type    : MySQL
 Target Server Version : 50718
 File Encoding         : 65001

 Date: 14/09/2020 08:27:28
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for RFID_log
-- ----------------------------
DROP TABLE IF EXISTS `RFID_log`;
CREATE TABLE `RFID_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `log_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  `hardware_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `RFID_log_user_id_fk`(`user_id`) USING BTREE,
  INDEX `RFID_log_hardware_uuid_fk`(`hardware_uuid`) USING BTREE,
  CONSTRAINT `RFID_log_hardware_uuid_fk` FOREIGN KEY (`hardware_uuid`) REFERENCES `hardware` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `RFID_log_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of RFID_log
-- ----------------------------

-- ----------------------------
-- Table structure for hardware
-- ----------------------------
DROP TABLE IF EXISTS `hardware`;
CREATE TABLE `hardware`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'noname',
  `temperature_limit` decimal(6, 2) NOT NULL DEFAULT 35.00,
  `humidity_limit` decimal(6, 2) NOT NULL DEFAULT 50.00,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `hardware_uuid_uindex`(`uuid`) USING BTREE,
  UNIQUE INDEX `hardware_uuid_uindex_2`(`uuid`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hardware
-- ----------------------------
INSERT INTO `hardware` VALUES (1, '782c8018-ef15-11ea-82cd-8878732c3ecb', 'noname', 35.00, 50.00);
INSERT INTO `hardware` VALUES (2, '89c1c3f6-ef15-11ea-85f9-8878732c3ecb', 'noname', 35.00, 50.00);
INSERT INTO `hardware` VALUES (5, '404db47e-f244-11ea-9db8-8878732c3ecb', 'noname', 35.00, 50.00);
INSERT INTO `hardware` VALUES (6, 'dd91031e-f61c-11ea-979b-8878732c3ecb', 'noname', 35.00, 50.00);
INSERT INTO `hardware` VALUES (7, '5ba8e802-f61f-11ea-a130-8878732c3ecb', 'noname', 35.00, 50.00);

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES (1, 'admin');
INSERT INTO `role` VALUES (2, 'manager');

-- ----------------------------
-- Table structure for sensor_data
-- ----------------------------
DROP TABLE IF EXISTS `sensor_data`;
CREATE TABLE `sensor_data`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `hardware_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `temperature` decimal(6, 2) NOT NULL,
  `humidity` decimal(6, 2) NULL DEFAULT NULL,
  `is_fire` tinyint(1) NOT NULL,
  `is_dry` tinyint(1) NOT NULL,
  `is_illum` tinyint(1) NOT NULL,
  `record_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `sensor_data_hardware_uuid_fk`(`hardware_uuid`) USING BTREE,
  CONSTRAINT `sensor_data_hardware_uuid_fk` FOREIGN KEY (`hardware_uuid`) REFERENCES `hardware` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 637 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;


-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(250) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `register_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_username_uindex`(`username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, '12345', '$2b$12$lEMWIsqkIBG.UJib1E4nkecTpyc8ooo51X7W9JKqIbcHGqEN2ckTC', '2020-09-10 10:36:43');
INSERT INTO `user` VALUES (3, '12345678', '$2b$12$cK12El7C33YpN8NBkofD3uh8ddat9Jnbbd1jk94IsSEvoXa6Y/Shu', '2020-09-10 10:39:35');
INSERT INTO `user` VALUES (4, 'zhazha', '$2b$12$Oj1xtKBBDKixm8IyCBxKLuB4P8DvucK8iPaL4XZiAST7KB6i1CoGK', '2020-09-11 21:58:31');
INSERT INTO `user` VALUES (5, 'admin', '$2b$12$I06rTHsFOhUiAF6T9zU3Zegm8qnh9KUelFWZLYu9L.LyWxiNhKG32', '2020-09-11 22:13:57');
INSERT INTO `user` VALUES (6, '马骕駸', '$2b$12$5LnEvRrkJoZyqunsHaZZr.bq7d56JtqRGzXmtZHq3AdmJBdC.lk6G', '2020-09-14 08:22:01');

-- ----------------------------
-- Table structure for user_hardware
-- ----------------------------
DROP TABLE IF EXISTS `user_hardware`;
CREATE TABLE `user_hardware`  (
  `user_id` bigint(20) NOT NULL,
  `hardware_uuid` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  INDEX `user_hardware_user_id_fk`(`user_id`) USING BTREE,
  INDEX `user_hardware_hardware_uuid_fk`(`hardware_uuid`) USING BTREE,
  CONSTRAINT `user_hardware_hardware_uuid_fk` FOREIGN KEY (`hardware_uuid`) REFERENCES `hardware` (`uuid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_hardware_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_hardware
-- ----------------------------

-- ----------------------------
-- Table structure for user_roles
-- ----------------------------
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles`  (
  `user_id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  INDEX `user_roles_role_id_fk`(`role_id`) USING BTREE,
  INDEX `user_roles_user_id_fk`(`user_id`) USING BTREE,
  CONSTRAINT `user_roles_role_id_fk` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `user_roles_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_roles
-- ----------------------------
INSERT INTO `user_roles` VALUES (1, 2);
INSERT INTO `user_roles` VALUES (3, 2);
INSERT INTO `user_roles` VALUES (4, 2);
INSERT INTO `user_roles` VALUES (5, 2);
INSERT INTO `user_roles` VALUES (5, 1);
INSERT INTO `user_roles` VALUES (6, 2);

SET FOREIGN_KEY_CHECKS = 1;
