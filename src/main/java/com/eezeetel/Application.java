package com.eezeetel;

import com.eezeetel.auth.*;
import com.eezeetel.customerapp.ProcessTransaction;
import com.eezeetel.filters.HttpHeadFilter;
import com.eezeetel.job.*;
import com.eezeetel.listener.SessionListener;
import com.eezeetel.service.CustomerBalanceReportService;
import com.eezeetel.service.GroupBalanceReportService;
import com.eezeetel.service.TransactionService;
import com.eezeetel.util.HibernateUtil;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.SecurityProperties;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.boot.context.embedded.ErrorPage;
import org.springframework.boot.context.web.SpringBootServletInitializer;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.data.web.config.EnableSpringDataWebSupport;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.scheduling.quartz.CronTriggerFactoryBean;
import org.springframework.scheduling.quartz.JobDetailFactoryBean;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.context.request.RequestContextListener;
import org.springframework.web.servlet.config.annotation.*;
import org.springframework.web.servlet.view.InternalResourceViewResolver;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.sql.DataSource;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

@SpringBootApplication
@ComponentScan({"com.eezeetel"})
public class Application extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(Application.class);
    }

    @Override
    public void onStartup(ServletContext servletContext) throws ServletException {
        servletContext.setInitParameter("Customer_Group_ID", "1");
        servletContext.setInitParameter("Country", "UK");

        servletContext.addFilter("httpHeadFilter", HttpHeadFilter.class).addMappingForUrlPatterns(null, false, "/*");

        super.onStartup(servletContext);
    }

    public static void main(String[] args) throws Exception {
        SpringApplication.run(Application.class, args);
    }

    @Bean
    public SessionListener sessionListener() {
        return new SessionListener();
    }

    @Bean
    public RequestContextListener requestContextListener() {
        return new RequestContextListener();
    }

    @Bean
    public EmbeddedServletContainerCustomizer containerCustomizer() {
        return (container -> {
            ErrorPage error404Page = new ErrorPage(HttpStatus.NOT_FOUND, "/");
            container.addErrorPages(error404Page);
        });
    }
}

@EnableWebMvc
@Configuration
@EnableSpringDataWebSupport
class DefaultView extends WebMvcConfigurerAdapter {

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        /*registry.addViewController("/").setViewName("index");
        registry.setOrder(Ordered.HIGHEST_PRECEDENCE);*/
        super.addViewControllers(registry);
    }

    @Bean
    public InternalResourceViewResolver getInternalResourceViewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setPrefix("/");
        resolver.setSuffix(".jsp");
        return resolver;
    }

    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/js/**", "/css/**", "/images/**", "/fonts/**", "/Product_Images/**", "/taajtopup files/**", "/new_images/**")
                .addResourceLocations("/js/", "/css/", "/images/", "/fonts/", "file:///D:/Installations/Tomcat/Product_Images/", "/taajtopup files/", "file:///var/www/html/new_images/")
                .setCachePeriod(60 * 60 * 4);
    }
}

@Configuration
@Order(SecurityProperties.ACCESS_OVERRIDE_ORDER)
class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    @Autowired
    private CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler;

    @Autowired
    private CustomAccessDeniedHandler customAccessDeniedHandler;

    @Autowired
    private CustomLogoutHandler customLogoutHandler;

    @Autowired
    private CustomPasswordEncoder customPasswordEncoder;

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
                .csrf().disable()
                .authorizeRequests()
                .antMatchers(HttpMethod.OPTIONS,"/customer/**").permitAll()
                .antMatchers("/").permitAll()
                .antMatchers("/masteradmin/**").access("hasRole('Employee_Master_Admin')")
                .antMatchers("/admin/**").access("hasAnyRole('Group_Admin', 'Group_Manager')")
                .antMatchers("/mobileadmin/**").access("hasAnyRole('Mobile_Admin')")
                .antMatchers("/customer/**").access("hasAnyRole('Customer_Supervisor', 'Customer_User')")
                .and()
                .formLogin()
                .loginPage("/")
                .loginProcessingUrl("/login")
                .usernameParameter("j_username")
                .passwordParameter("j_password")
                .successHandler(customAuthenticationSuccessHandler)
                .failureUrl("/?failed=1")
                .permitAll()
                .and()
                .exceptionHandling().accessDeniedHandler(customAccessDeniedHandler)
                .and()
                .logout()
                        //.addLogoutHandler(customLogoutHandler)
                .logoutUrl("/logout")
                .logoutSuccessUrl("/")
                .permitAll();
    }

    @Autowired
    public void configureGlobal(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(customUserDetailsService).passwordEncoder(customPasswordEncoder);
    }
}

@Configuration
@EnableTransactionManagement
@EnableJpaRepositories("com.eezeetel.repository")
class SpringData {

    private static final String HIBERNATE_DIALECT = "hibernate.dialect";
    private static final String HIBERNATE_HBM2DDL_AUTO = "hibernate.hbm2ddl.auto";
    private static final String HIBERNATE_SHOW_SQL = "hibernate.show_sql";
    private static final String MAX_SIZE = "hibernate.c3p0.max_size";
    private static final String PACKAGES_TO_SCAN = "com.eezeetel.entity";
    private static final String MAX_FETCH_DEPTH = "hibernate.max_fetch_depth";
    private static final String ORDER_INSERTS = "hibernate.order_inserts";
    private static final String ORDER_UPDATES = "hibernate.order_updates";
    private static final String BATCH_SIZE = "hibernate.jdbc.batch_size";
    private static final String MERGE_OBSERVER = "hibernate.event.merge.entity_copy_observer";

    @Bean
    public DataSource dataSource() {
        try {
            DriverManagerDataSource dataSource = new DriverManagerDataSource();
            dataSource.setDriverClassName("com.mysql.jdbc.Driver");
            dataSource.setUrl("jdbc:mysql://localhost/genericappdb_new?autoReconnect=true&amp;createDatabaseIfNotExist=true&amp;");
            dataSource.setUsername("root");
            dataSource.setPassword("root");
            return dataSource;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Bean
    public LocalContainerEntityManagerFactoryBean entityManagerFactory() {
        LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
        em.setPackagesToScan(PACKAGES_TO_SCAN);
        em.setDataSource(dataSource());

        HibernateJpaVendorAdapter vendor = new HibernateJpaVendorAdapter();
        vendor.setShowSql(false);
        em.setJpaVendorAdapter(vendor);
        em.setJpaProperties(hibProperties());
        return em;
    }

    @Bean
    public JpaTransactionManager transactionManager() {
        JpaTransactionManager transactionManager = new JpaTransactionManager();
        transactionManager.setEntityManagerFactory(entityManagerFactory().getObject());
        return transactionManager;
    }

    private Properties hibProperties() {
        Properties properties = new Properties();
        properties.put(HIBERNATE_DIALECT, "org.hibernate.dialect.MySQL5InnoDBDialect");
        properties.put(HIBERNATE_HBM2DDL_AUTO, "update");
        properties.put(HIBERNATE_SHOW_SQL, "false");
        properties.put(MAX_SIZE, 25);
        properties.put(MAX_FETCH_DEPTH, 2);
        properties.put(ORDER_INSERTS, true);
        properties.put(ORDER_UPDATES, true);
        properties.put(BATCH_SIZE, 5);
        properties.put(MERGE_OBSERVER, "allow");
        return properties;
    }

    @Bean
    public HibernateUtil hibernateUtil() {
        HibernateUtil util = new HibernateUtil();
        util.setSessionFactory(entityManagerFactory().getObject().unwrap(SessionFactory.class));
        return util;
    }
}

@Configuration
class Quartz {

    @Autowired
    private ApplicationContext applicationContext;

    @Bean
    public JobDetailFactoryBean moveDataToHistoryJob() {
        JobDetailFactoryBean factory = new JobDetailFactoryBean();
        factory.setJobClass(MoveDataToHistory.class);
        return factory;
    }

    //Job is scheduled each hour
    @Bean
    public CronTriggerFactoryBean moveDataToHistoryCron() {
        CronTriggerFactoryBean stFactory = new CronTriggerFactoryBean();
        stFactory.setJobDetail(moveDataToHistoryJob().getObject());
        stFactory.setStartDelay(1000);
        stFactory.setCronExpression("0 0 0/1 * * ?");
        return stFactory;
    }

    @Bean
    public JobDetailFactoryBean transactionPostProcessJob() {
        JobDetailFactoryBean factory = new JobDetailFactoryBean();
        factory.setJobClass(TransactionPostProcess.class);
        Map<String, Object> map = new HashMap<>();
        map.put("processTransaction", applicationContext.getBean(ProcessTransaction.class));
        map.put("transactionService", applicationContext.getBean(TransactionService.class));
        factory.setJobDataAsMap(map);
        return factory;
    }

    //Job is scheduled after every 6 hours
    @Bean
    public CronTriggerFactoryBean transactionPostProcessCron() {
        CronTriggerFactoryBean stFactory = new CronTriggerFactoryBean();
        stFactory.setJobDetail(transactionPostProcessJob().getObject());
        stFactory.setStartDelay(60 * 60 * 1000);
        stFactory.setCronExpression("0 0 0/6 * * ?");
        return stFactory;
    }

    @Bean
    public JobDetailFactoryBean removeBackupFileJob() {
        JobDetailFactoryBean factory = new JobDetailFactoryBean();
        factory.setJobClass(RemoveBackupFile.class);
        return factory;
    }

    //Job is scheduled after every 6 hours
    @Bean
    public CronTriggerFactoryBean removeBackupFileCron() {
        CronTriggerFactoryBean stFactory = new CronTriggerFactoryBean();
        stFactory.setJobDetail(removeBackupFileJob().getObject());
        stFactory.setStartDelay(60 * 1000);
        stFactory.setCronExpression("0 0 0/6 * * ?");
        return stFactory;
    }

    @Bean
    public JobDetailFactoryBean dailyCustomerBalanceReportJob() {
        JobDetailFactoryBean factory = new JobDetailFactoryBean();
        factory.setJobClass(DailyCustomerBalanceReport.class);
        Map<String, Object> map = new HashMap<>();
        map.put("customerBalanceReportService", applicationContext.getBean(CustomerBalanceReportService.class));
        factory.setJobDataAsMap(map);
        return factory;
    }

    //Job is scheduled every midnight
    @Bean
    public CronTriggerFactoryBean dailyCustomerBalanceReportCron() {
        CronTriggerFactoryBean stFactory = new CronTriggerFactoryBean();
        stFactory.setJobDetail(dailyCustomerBalanceReportJob().getObject());
        stFactory.setStartDelay(1000);
        stFactory.setCronExpression("0 0 0 * * ?");
        return stFactory;
    }

    @Bean
    public JobDetailFactoryBean dailyGroupBalanceReportJob() {
        JobDetailFactoryBean factory = new JobDetailFactoryBean();
        factory.setJobClass(DailyGroupBalanceReport.class);
        Map<String, Object> map = new HashMap<>();
        map.put("groupBalanceReportService", applicationContext.getBean(GroupBalanceReportService.class));
        factory.setJobDataAsMap(map);
        return factory;
    }

    //Job is scheduled every midnight
    @Bean
    public CronTriggerFactoryBean dailyGroupBalanceReportCron() {
        CronTriggerFactoryBean stFactory = new CronTriggerFactoryBean();
        stFactory.setJobDetail(dailyGroupBalanceReportJob().getObject());
        stFactory.setStartDelay(1000);
        stFactory.setCronExpression("0 0 0 * * ?");
        return stFactory;
    }

    @Bean
    public SchedulerFactoryBean schedulerFactoryBean() {
        SchedulerFactoryBean scheduler = new SchedulerFactoryBean();

        scheduler.setTriggers(
                moveDataToHistoryCron().getObject(),
                transactionPostProcessCron().getObject(),
                removeBackupFileCron().getObject(),
                dailyCustomerBalanceReportCron().getObject(),
                dailyGroupBalanceReportCron().getObject()
        );

        return scheduler;
    }
}
