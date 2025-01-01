{config, ...}: {
  config = {
    boot = {
      ### Use zenpower instead of k10temp for improved sensor readings
      blacklistedKernelModules = ["k10temp"];
      extraModulePackages = [config.boot.kernelPackages.zenpower];
      kernelModules = ["zenpower"];

      ### AMD CPU scaling for energy efficiency.
      # https://www.kernel.org/doc/html/latest/admin-guide/pm/amd-pstate.html
      kernelParams = ["amd_pstate=active"];
    };
  };
}
