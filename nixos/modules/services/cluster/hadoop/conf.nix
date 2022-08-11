{ cfg, pkgs, lib }:
let
  propertyXml = name: value: lib.optionalString (value != null) ''
    <property>
      <name>${name}</name>
      <value>${builtins.toString value}</value>
    </property>
  '';
  siteXml = fileName: properties: pkgs.writeTextDir fileName ''
    <?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <!-- generated by NixOS -->
    <configuration>
      ${builtins.concatStringsSep "\n" (pkgs.lib.mapAttrsToList propertyXml properties)}
    </configuration>
  '';
  cfgLine = name: value: ''
    ${name}=${builtins.toString value}
  '';
  cfgFile = fileName: properties: pkgs.writeTextDir fileName ''
    # generated by NixOS
    ${builtins.concatStringsSep "" (pkgs.lib.mapAttrsToList cfgLine properties)}
  '';
  userFunctions = ''
    hadoop_verify_logdir() {
      echo Skipping verification of log directory
    }
  '';
  hadoopEnv = ''
    export HADOOP_LOG_DIR=/tmp/hadoop/$USER
  '';
in
pkgs.runCommand "hadoop-conf" {} (with cfg; ''
  mkdir -p $out/
  cp ${siteXml "core-site.xml" (coreSite // coreSiteInternal)}/* $out/
  cp ${siteXml "hdfs-site.xml" (hdfsSiteDefault // hdfsSite // hdfsSiteInternal)}/* $out/
  cp ${siteXml "hbase-site.xml" (hbaseSiteDefault // hbaseSite // hbaseSiteInternal)}/* $out/
  cp ${siteXml "mapred-site.xml" (mapredSiteDefault // mapredSite)}/* $out/
  cp ${siteXml "yarn-site.xml" (yarnSiteDefault // yarnSite // yarnSiteInternal)}/* $out/
  cp ${siteXml "httpfs-site.xml" httpfsSite}/* $out/
  cp ${cfgFile "container-executor.cfg" containerExecutorCfg}/* $out/
  cp ${pkgs.writeTextDir "hadoop-user-functions.sh" userFunctions}/* $out/
  cp ${pkgs.writeTextDir "hadoop-env.sh" hadoopEnv}/* $out/
  cp ${log4jProperties} $out/log4j.properties
  ${lib.concatMapStringsSep "\n" (dir: "cp -f -r ${dir}/* $out/") extraConfDirs}
'')
