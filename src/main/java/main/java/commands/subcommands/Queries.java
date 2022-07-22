package main.java.commands.subcommands;


import main.java.commands.subcommands.ExecuteQueries.LatSearch;
import main.java.commands.subcommands.ExecuteQueries.PostalSearch;
import main.java.commands.subcommands.ExecuteQueries.ShowListings;
import picocli.CommandLine;

import java.util.concurrent.Callable;


@CommandLine.Command(name = "Query",
        mixinStandardHelpOptions = true,
        description = "this is the Query tool ",
        subcommands = {
                ShowListings.class,
                LatSearch.class,
                PostalSearch.class
        })
public class Queries implements Callable<Integer> {
    public static void main(String[] args) {

    }

    @Override
    public Integer call() throws Exception {
        return null;
    }
}
