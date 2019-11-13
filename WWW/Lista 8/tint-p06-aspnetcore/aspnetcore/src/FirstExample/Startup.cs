using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using FirstExample.Services;

namespace FirstExample
{
    public class Startup
    {
        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit http://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddSingleton<IGreeter, Greeter>();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory, IGreeter greeter)
        {
            loggerFactory.AddConsole();

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                //app.UseExceptionHandler("/error");
                app.UseExceptionHandler(new ExceptionHandlerOptions {
                    ExceptionHandler = context => context.Response.WriteAsync("Houston, mamy problem")
                });
            }

            app.UseWelcomePage(new WelcomePageOptions { Path = "/welcome" });

            //app.UseDefaultFiles();
            app.UseStaticFiles();
            //app.UseFileServer();

            app.Run(async (context) =>
            {
                //throw new Exception("Coś się wy...");
                await context.Response.WriteAsync(greeter.SayHello());
            });
        }
    }
}
