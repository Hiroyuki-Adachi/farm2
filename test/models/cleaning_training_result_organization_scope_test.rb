require "test_helper"

class CleaningTrainingResultOrganizationScopeTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:org)
    @other_organization = organizations(:org2)
    @other_work = works(:work_other_org)
    @other_worker = workers(:worker_other_org)
    @other_home = homes(:home_other_org)
    @other_land = lands(:land_other_org)

    create_cleaning_records
    create_training_records
    create_chemical_work_type
    create_adjustment
    create_broccoli_harvest
    create_whole_crop_records
  end

  test "親レコードの組織で清掃・訓練・その他実績を絞り込む" do
    [
      @other_cleaning,
      @other_cleaning_institution,
      @other_cleaning_target,
      @other_training,
      @other_training_type,
      @other_accident,
      @other_chemical_work_type,
      @other_adjustment,
      @other_broccoli_harvest,
      @other_whole_crop_land,
      @other_whole_crop_roll
    ].each { |record| assert_scoped(record) }
  end

  test "研修には作業と同じ組織の講師と予定だけを指定できる" do
    training = Training.new(
      work: works(:work_study_create), teacher: @other_worker, study: @other_schedule
    )

    assert_not training.valid?
    assert training.errors.added?(:worker_id, "は作業と同じ組織の作業者を指定してください。")
    assert training.errors.added?(:schedule_id, "は作業と同じ組織の予定を指定してください。")
  end

  test "ヒヤリハットには作業と同じ組織の調査責任者と対象者だけを指定できる" do
    accident = Accident.new(
      work: works(:works1), investigator: @other_worker, audience: @other_worker,
      accident_type_id: :rule, investigated_on: Date.new(2015, 5, 1)
    )

    assert_not accident.valid?
    assert accident.errors.added?(:investigator_id, "は作業と同じ組織の作業者を指定してください。")
    assert accident.errors.added?(:audience_id, "は作業と同じ組織の作業者を指定してください。")
  end

  test "研修候補予定に他組織の予定を含めない" do
    assert_not_includes Schedule.for_training(works(:work_study_create)), @other_schedule
  end

  private

  def create_cleaning_records
    @other_cleaning = Cleaning.create!(work: @other_work)
    @other_cleaning_institution = CleaningInstitution.create!(
      cleaning: @other_cleaning, institution: institutions(:jimusho)
    )
    @other_cleaning_target = CleaningCleaningTarget.create!(
      cleaning: @other_cleaning, cleaning_target: cleaning_targets(:cleaning_target1)
    )
  end

  def create_training_records
    @other_schedule = Schedule.create!(
      organization: @other_organization, term: 2015, worked_at: Date.new(2015, 5, 1),
      work_kind: work_kinds(:work_kinds2),
      name: "別組織研修", work_flag: false, created_by: @other_worker.id
    )
    @other_training = Training.create!(
      work: @other_work, teacher: @other_worker, study: @other_schedule
    )
    @other_training_type = TrainingTrainingType.create!(
      training: @other_training, training_type: training_types(:training_type1)
    )
    @other_accident = Accident.create!(
      work: @other_work, investigator: @other_worker, audience: @other_worker,
      accident_type_id: :rule, investigated_on: Date.new(2015, 5, 1)
    )
  end

  def create_chemical_work_type
    chemical = Chemical.create!(
      organization: @other_organization, chemical_type: chemical_types(:chemical_types1),
      name: "別組織薬剤", phonetic: "べつそしきやくざい", display_order: 1
    )
    chemical_term = ChemicalTerm.create!(
      organization: @other_organization, chemical: chemical, term: 2015
    )
    @other_chemical_work_type = ChemicalWorkType.create!(
      chemical_term: chemical_term, work_type: work_types(:work_types1), quantity: 1
    )
  end

  def create_adjustment
    drying = Drying.create!(
      home: @other_home, work_type: work_types(:work_types1), term: 2015,
      carried_on: Date.new(2015, 10, 10), drying_type_id: :another
    )
    @other_adjustment = Adjustment.create!(drying: drying, home: @other_home)
  end

  def create_broccoli_harvest
    broccoli = WorkBroccoli.create!(work: @other_work, shipped_on: Date.new(2015, 5, 1))
    @other_broccoli_harvest = BroccoliHarvest.create!(
      work_broccoli: broccoli, broccoli_rank_id: 1, broccoli_size_id: 1
    )
  end

  def create_whole_crop_records
    whole_crop = WorkWholeCrop.create!(work: @other_work)
    work_land = WorkLand.create!(work: @other_work, land: @other_land, display_order: 1)
    @other_whole_crop_land = WholeCropLand.create!(
      work_whole_crop: whole_crop, work_land: work_land, display_order: 1
    )
    @other_whole_crop_roll = WholeCropRoll.create!(
      wcs_land: @other_whole_crop_land, display_order: 1, weight: 100
    )
  end

  def assert_scoped(record)
    assert record.class.for_organization(@other_organization).exists?(record.id), record.class.name
    assert_not record.class.for_organization(@organization).exists?(record.id), record.class.name
  end
end
