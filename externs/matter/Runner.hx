package matter;
import matter.Matter.IRunnerOptions;

@:native("Matter.Runner")
extern class Runner {
	static function create(?options:IRunnerOptions):Runner;
	static function run(runner:Runner, engine:Engine):Runner;
	var isFixed:Bool;
}
